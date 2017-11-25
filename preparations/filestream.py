endl = '\n'


class FileStream(object):

    def __init__(self, filename, mode='r'):
        if filename is None:
            self.fullname = None
            self.name = None
            self.file = ""
        else:
            self.fullname = filename if not filename is None else None
            self.name = self.fullname.split('/')[-1]
            self.file = open(self.fullname, mode) if not self.fullname is None else ""

    def __lshift__(self, lhs):
        if self.name is None:
            return None

        if type(lhs) == str:
            self.file.write(lhs)
        elif type(lhs) == FileStream:
            for line in lhs.file:
                self << line
        elif type(lhs) in (list, tuple):
            for line in lhs[:-1]:
                self << line << endl
            self << lhs[-1]
        elif lhs is None:
            self << ("#None" + "  None"*12 + endl) * 7
        else:
            self << str(lhs)
        return self

    def as_list(self):
        str_list = [""]
        if self.name is not None:
            fix = lambda line: line.replace('\n', '')
            str_list = [fix(string) for string in self.file]
        return str_list

    def as_line(self, separator=''):
        list = self.as_list()
        line = ""
        for l in list:
            line += separator + l
        return line

    def close(self):
        if self.name is not None:
            self.file.close()
        return self.fullname, self.name

    def __del__(self):
        self.close()