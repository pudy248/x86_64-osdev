class VectorSynthProvider(object):
    def __init__(self, valobj, dict):
        self.valobj = valobj
        self.count = None

    def num_children(self):
        if self.count is None:
            try:
                arr_val = self.arr.unsigned
                size_val = self.size.unsigned
                if arr_val == 0 or size_val == 0:
                    self.count = 0
                    return self.count
                self.count = size_val
            except:
                self.count = 0
        return self.count

    def get_child_index(self, name):
        try:
            return int(name.lstrip("[").rstrip("]"))
        except:
            return -1
        
    def get_child_at_index(self, index):
        if index < 0:
            return None
        if index >= self.num_children():
            return None
        try:
            offset = index * self.data_size
            return self.arr.CreateChildAtOffset(
                "[" + str(index) + "]", offset, self.data_type
            )
        except:
            return "Except"

    def update(self):
        self.count = None
        try:
            self.arr = self.valobj.GetChildMemberWithName("m_arr").GetChildMemberWithName("ptr")
            self.size = self.valobj.GetChildMemberWithName("m_size")
            self.data_type = self.valobj.GetType().GetTemplateArgumentType(0)
            self.data_size = self.data_type.GetByteSize()
            if (
                self.arr.IsValid()
                and self.size.IsValid()
                and self.data_type.IsValid()
            ):
                self.count = None
            else:
                self.count = 0
        except:
            self.count = 0
        return False
    
    def has_children(self):
        return True

class VectorSynthProviderDeref(object):
    def __init__(self, valobj, dict):
        self.valobj = valobj
        self.count = None

    def num_children(self):
        if self.count is None:
            try:
                arr_val = self.arr.unsigned
                size_val = self.size.unsigned
                if arr_val == 0 or size_val == 0:
                    self.count = 0
                    return self.count
                self.count = size_val
            except:
                self.count = 0
        return self.count

    def get_child_index(self, name):
        try:
            return int(name.lstrip("[").rstrip("]"))
        except:
            return -1
        
    def get_child_at_index(self, index):
        if index < 0:
            return None
        if index >= self.num_children():
            return None
        try:
            offset = index * self.ptr_size
            return self.arr.CreateChildAtOffset(
                "[" + str(index) + "]", offset, self.ptr_type
            ).Dereference()
        except:
            return "Except"

    def update(self):
        self.count = None
        try:
            self.arr = self.valobj.GetChildMemberWithName("m_arr").GetChildMemberWithName("ptr")
            self.size = self.valobj.GetChildMemberWithName("m_size")
            self.ptr_type = self.valobj.type.GetTemplateArgumentType(0)
            self.ptr_size = self.ptr_type.GetByteSize()
            if (
                self.arr.IsValid()
                and self.size.IsValid()
                and self.ptr_type.IsValid()
            ):
                self.count = None
            else:
                self.count = 0
        except:
            self.count = 0
        return False
    
    def has_children(self):
        return True


class BytespanSynthProvider(object):
    def __init__(self, valobj, dict):
        self.valobj = valobj
        self.count = None

    def num_children(self):
        if self.count is None:
            arr_val = self.arr.unsigned
            size_val = int(self.size)
            if arr_val == 0 or size_val == 0:
                self.count = 0
                return self.count
            self.count = size_val
        return self.count

    def get_child_index(self, name):
        print("get child index")
        print(name)
        try:
            return int(name.lstrip("[").rstrip("]"))
        except:
            return -1
        
    def get_child_at_index(self, index):
        print("get child at index")
        print(index)
        if index < 0:
            return None
        if index >= self.num_children():
            return None
        try:
            offset = index * self.ptr_size
            return self.arr.CreateChildAtOffset(
                "[" + str(index) + "]", offset, self.ptr_type
            )
        except:
            return "Except"

    def update(self):
        self.count = None
        try:
            self.arr = self.valobj.GetChildMemberWithName("iter").GetChildMemberWithName("ptr")
            sent = self.valobj.GetChildMemberWithName("sentinel").GetChildMemberWithName("ptr")
            self.ptr_type = self.valobj.target.FindFirstType("std::byte")
            self.ptr_size = self.ptr_type.GetByteSize()
            self.size = (sent.unsigned - self.arr.unsigned) / self.ptr_size
            if (
                self.arr.IsValid()
                and self.ptr_type.IsValid()
            ):
                self.count = None
            else:
                self.count = 0
        except:
            self.count = 0
            print("Except")
        return False
    
    def has_children(self):
        return True

def char_container(valobj,internal_dict,options):
    begin = valobj.GetNonSyntheticValue().GetChildMemberWithName('iter').Cast(valobj.target.FindFirstType("char").GetPointerType())
    sentinel = valobj.GetNonSyntheticValue().GetChildMemberWithName('sentinel')
    s = ''
    for i in range(sentinel.unsigned - begin.unsigned):
        s = s + begin.GetChildAtIndex(i, 0, True).value[1:-1]
    return '"' + s + '"_RO'

def char_container_rw(valobj,internal_dict,options):
    arr = valobj.GetNonSyntheticValue().GetChildMemberWithName('m_arr').GetChildMemberWithName('ptr').Cast(valobj.target.FindFirstType("char").GetPointerType())
    size_v = valobj.GetNonSyntheticValue().GetChildMemberWithName('m_size').unsigned
    s = ''
    for i in range(size_v):
        s = s + arr.GetChildAtIndex(i, 0, True).value[1:-1]
    return '"' + s + '"_RW'

def function_address(valobj,internal_dict,options):
    ret = valobj.GetChildMemberWithName('ret').unsigned
    rbp = valobj.GetChildMemberWithName('rbp').unsigned
    display_name = None
    if ret != 0:
        addr = valobj.target.ResolveLoadAddress(ret)
        display_name = addr.function.GetDisplayName()
    if display_name is None:
        display_name = "(none)"
    
    return F"{rbp:08x} {ret:08x}: {display_name}"

def fat_file(valobj,internal_dict,options):
    return valobj.GetChildMemberWithName('inode').Dereference()

class StacktraceProvider(object):
    def __init__(self, valobj, dict):
        self.valobj = valobj
        self.count = None

    def num_children(self):
        if self.count is None:
            size_val = self.size.unsigned
            self.count = size_val
        return self.count

    def get_child_index(self, name):
        return int(name.lstrip("[").rstrip("]"))
        
    def get_child_at_index(self, index):
        if index < 0:
            return None
        if index >= self.num_children():
            return None
        offset = index * self.data_size
        val = self.arr_v.CreateChildAtOffset(
            "[" + str(index) + "]", offset, self.data_type
        )
        return val

    def update(self):
        self.count = None
        self.arr = self.valobj.GetChildMemberWithName("ptrs")
        self.arr_v = self.arr.GetChildMemberWithName("m_arr").GetChildMemberWithName('ptr')
        self.size = self.valobj.GetChildMemberWithName("num_ptrs")
        self.data_type = self.arr.type.GetTemplateArgumentType(0)
        self.data_size = self.data_type.GetByteSize()
        if (
            self.arr.IsValid()
            and self.size.IsValid()
            and self.data_type.IsValid()
        ):
            self.count = None
        else:
            self.count = 0
        return False
    
    def has_children(self):
        return True
