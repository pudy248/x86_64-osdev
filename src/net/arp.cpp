#include <cstdint>
#include <kstdio.hpp>
#include <kstdlib.hpp>
#include <net/arp.hpp>
#include <net/config.hpp>
#include <net/dhcp.hpp>
#include <net/net.hpp>
#include <stl/vector.hpp>
#include <sys/ktime.hpp>

vector<arp_entry> arp_table;

void arp_update(mac_t mac, ipv4_t ip) {
	if (ARP_LOG_UPDATE)
		qprintf<128>("[ARP] Update: %M %I\n", mac, ip);

	for (std::size_t i = 0; i < arp_table.size(); i++) {
		//if (mac == arp_table[i].mac) {
		//    arp_table[i].ip = ip;
		//    return;
		//}
		if (ip == arp_table[i].ip) {
			arp_table[i].mac = mac;
			return;
		}
	}
	arp_table.append({ mac, ip });
}

ipv4_t arp_translate_mac(mac_t mac) {
	for (std::size_t i = 0; i < arp_table.size(); i++) {
		if (mac == arp_table[i].mac)
			return arp_table[i].ip;
	}
	return 0;
}

static mac_t arp_translate_ip_local(ipv4_t ip) {
	for (std::size_t i = 0; i < arp_table.size(); i++)
		if (ip == arp_table[i].ip)
			return arp_table[i].mac;

	int tries = 0;
try_again:
	timepoint t = timepoint::now();
	arp_whois(ip);
	while (tries < ARP_MAX_RETRIES) {
		net_fwdall();
		for (std::size_t i = 0; i < arp_table.size(); i++)
			if (ip == arp_table[i].ip)
				return arp_table[i].mac;
		if (timepoint::now() - t > 0.1) {
			tries++;
			goto try_again;
		}
	}
	return 0;
}

mac_t arp_translate_ip(ipv4_t ip) {
	if (ip == 0xffffffffU)
		return MAC_BCAST;

	for (std::size_t i = 0; i < arp_table.size(); i++)
		if (ip == arp_table[i].ip)
			return arp_table[i].mac;

	// this is control flow hell
	if (active_lease.duration.rep) {
		if ((ip & active_lease.subnet_mask) == (global_ip & active_lease.subnet_mask))
			if (mac_t addr = arp_translate_ip_local(ip); addr)
				return addr;
		if (ip != active_lease.router) {
			mac_t m = arp_translate_ip(active_lease.router);
			arp_update(m, ip);
			return m;
		} else
			return 0;
	} else
		return arp_translate_ip_local(ip);
}

void arp_process(eth_packet p) {
	arp_header* h = (arp_header*)p.b.data_begin;
	ipv4_t selfIP = 0, targetIP = 0;
	mac_t selfMac = 0, targetMac = 0;

	memcpy(&selfIP, &h->selfIP, 4);
	memcpy(&targetIP, &h->targetIP, 4);
	memcpy(&selfMac, &h->selfMac, 6);
	memcpy(&targetMac, &h->targetMac, 6);
	bool sMac = !!selfMac;
	bool sIp = !!selfIP;
	bool tMac = !!targetMac;
	bool tIp = !!targetIP;

	switch ((sMac << 0) | (sIp << 1) | (tMac << 2) | (tIp << 3) | (htons(h->op) << 4)) {
	case 0x19: //Probe
		if (ARP_LOG)
			printf("[ARP] %M wants to know: Is %I available?\n", selfMac, targetIP);
		if (targetIP == global_ip) {
			if (ARP_LOG)
				printf("[ARP] No, %I belongs to %M.\n", global_ip, global_mac.as_int);
			arp_send(2, arp_entry(global_mac.as_int, global_ip), arp_entry(selfMac, selfIP));
		}
		break;
	case 0x1B:
		if (selfIP != targetIP) { //Request
			if (ARP_LOG)
				printf("[ARP] %I wants to know: Who is %I?\n", selfIP, targetIP);
			if (targetIP == new_ipv4(10, 0, 2, 15))
				global_ip = targetIP;

			if (targetIP == global_ip) {
				if (ARP_LOG)
					printf("[ARP] Responding to %I: %I is %M.\n", selfIP, global_ip, global_mac.as_int);
				arp_send(2, arp_entry(global_mac.as_int, global_ip), arp_entry(selfMac, selfIP));
			}
		} else { //Gratuitous announcement
			if (ARP_LOG)
				printf("[ARP] Announcement: %I belongs to %M.\n", selfIP, selfMac);
		}
		break;
	case 0x1F:
		if (targetIP == global_ip) {
			if (ARP_LOG)
				printf("[ARP] Responding to %I: %I is %M.\n", selfIP, global_ip, global_mac.as_int);
			arp_send(2, arp_entry(global_mac.as_int, global_ip), arp_entry(selfMac, selfIP));
		}
		break;
	case 0x2F:
		if (ARP_LOG)
			printf("[ARP] Reply: %I is %M.\n", selfIP, targetIP, targetMac);
		arp_update(targetMac, targetIP);
		break;
	case 0x4F:
		if (ARP_LOG)
			printf("[ARP] Reply: %M is %I.\n", selfIP, targetMac, targetIP);
		arp_update(targetMac, targetIP);
		break;
	default:
		printf("[ARP] Not sure what to do with %s. (%M %I) (%M %I)\n", htons(h->op) == 2 ? "reply" : "request",
			   h->selfMac, h->selfIP, h->targetMac, h->targetIP);
		break;
	}
	kfree(p.b.frame_begin);
}

net_async_t arp_send(uint16_t op, arp_entry self, arp_entry target) {
	mac_t eth_dst;
	if (!target.mac || (op == ARP::TYPE_REQUEST && target.mac == self.mac))
		eth_dst = MAC_BCAST;
	else
		eth_dst = target.mac;

	net_buffer_t buf = eth_new(sizeof(arp_header));
	arp_header* h = (arp_header*)buf.data_begin;
	h->htype = htons(HTYPE::ETH);
	h->ptype = htons(ARP::PTYPE_IPv4);
	h->hlen = 6;
	h->plen = 4;
	h->op = htons(op);
	memcpy(&h->selfIP, &self.ip, 4);
	memcpy(&h->targetIP, &target.ip, 4);
	memcpy(&h->selfMac, &self.mac, 6);
	memcpy(&h->targetMac, &target.mac, 6);

	eth_info eth;
	eth.dst_mac = eth_dst;
	eth.src_mac = self.mac;
	eth.ethertype = ETHERTYPE::ARP;
	return eth_send({ eth, buf });
}

net_async_t arp_whois(mac_t mac) {
	return arp_send(ARP::TYPE_REQUEST, arp_entry(global_mac.as_int, global_ip), arp_entry(mac, 0));
}
net_async_t arp_whois(ipv4_t ip) {
	return arp_send(ARP::TYPE_PROBE, arp_entry(global_mac.as_int, global_ip), arp_entry(0, ip));
}

net_async_t arp_announce(ipv4_t ip) {
	net_update_ip(ip);
	if (ARP_LOG)
		printf("[ARP] Announcement: %I belongs to %M.\n", global_ip, global_mac.as_int);
	return arp_send(ARP::TYPE_PROBE, arp_entry(global_mac.as_int, global_ip), arp_entry(0, global_ip));
}
