import lldb.formatters.Logger

class VectorSynthProvider(object):
    def __init__(self, valobj, dict):
        self.valobj = valobj
        self.count = None

    def num_children(self):
        if self.count is None:
            try:
                arr_val = self.arr.GetValueAsUnsigned(0)
                size_val = self.size.GetValueAsUnsigned(0)
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
        logger = lldb.formatters.Logger.Logger()
        logger >> "Retrieving child " + str(index)
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
            return None

    def update(self):
        self.count = None
        try:
            self.arr = self.valobj.GetChildMemberWithName("m_arr")
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
                arr_val = self.arr.GetValueAsUnsigned(0)
                size_val = self.size.GetValueAsUnsigned(0)
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
        logger = lldb.formatters.Logger.Logger()
        logger >> "Retrieving child " + str(index)
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
            return None

    def update(self):
        self.count = None
        try:
            self.arr = self.valobj.GetChildMemberWithName("m_arr")
            self.size = self.valobj.GetChildMemberWithName("m_size")
            self.ptr_type = self.valobj.GetType().GetTemplateArgumentType(0)
            self.ptr_size = self.ptr_type.GetByteSize()
            self.data_type = self.ptr_type.GetPointeeType()
            if (
                self.arr.IsValid()
                and self.size.IsValid()
                and self.ptr_type.IsValid()
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

def char_container(valobj,internal_dict,options):
    arr = valobj.GetChildMemberWithName('m_arr')
    size_v = valobj.GetChildMemberWithName('m_size').GetValueAsUnsigned(0)
    str = ''
    for i in range(size_v):
        str = str + arr.GetChildAtIndex(i, 0, True).GetValue()[1:-1]
    return '"' + str + '"_RO'

def char_container_rw(valobj,internal_dict,options):
    arr = valobj.GetChildMemberWithName('m_arr')
    size_v = valobj.GetChildMemberWithName('m_size').GetValueAsUnsigned(0)
    str = ''
    for i in range(size_v):
        str = str + arr.GetChildAtIndex(i, 0, True).GetValue()[1:-1]
    return '"' + str + '"_RW'

def function_address(valobj,internal_dict,options):
    ret = valobj.GetChildMemberWithName('ret').GetValueAsUnsigned(0)
    rbp = valobj.GetChildMemberWithName('rbp').GetValueAsUnsigned(0)
    display_name = None
    if ret != 0:
        addr = valobj.target.ResolveLoadAddress(ret)
        display_name = addr.GetFunction().GetDisplayName()
    if display_name is None:
        display_name = ""
    
    return F"{rbp:08x} {ret:08x}: " + display_name

class StacktraceProvider(object):
    def __init__(self, valobj, dict):
        self.valobj = valobj
        self.count = None

    def num_children(self):
        if self.count is None:
            size_val = self.size.GetValueAsUnsigned(0)
            self.count = size_val
        return self.count

    def get_child_index(self, name):
        return int(name.lstrip("[").rstrip("]"))
        
    def get_child_at_index(self, index):
        logger = lldb.formatters.Logger.Logger()
        logger >> "Retrieving child " + str(index)
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
        self.arr_v = self.arr.GetChildMemberWithName("m_arr")
        self.size = self.valobj.GetChildMemberWithName("num_ptrs")
        self.data_type = self.arr.GetType().GetTemplateArgumentType(0)
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
