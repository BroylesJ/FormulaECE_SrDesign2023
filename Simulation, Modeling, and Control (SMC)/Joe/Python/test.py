import re
import pandas as pd


def parse(filepath):

    data = []
    with open(filepath, 'r') as file:
        line = file.readline()
        while line:
            reg_match = _RegExLib(line)

            if reg_match.X:
                X = reg_match.X.group(1)

            if reg_match.Y:
                Y = reg_match.Y.group(1)
                Y = int(Y)
                
            if reg_match.Z:
                Z = reg_match.Z.group(1)
                Z = int(Z)


            line = file.readline()

        data = pd.DataFrame(data)
        data.set_index(['X', 'Y', 'Z'], inplace=True)
        # consolidate df to remove nans
        data = data.groupby(level=data.index.names).first()
        # upgrade Score from float to integer
        data = data.apply(pd.to_numeric, errors='ignore')
    return data


class _RegExLib:
    """Set up regular expressions"""
    # use https://regexper.com to visualise these if required
    _reg_X = re.compile('X = (.*)\n')
    _reg_Y = re.compile('Y = (.*)\n')
    _reg_Z = re.compile('Z = (.*)\n')


    def __init__(self, line):
        # check whether line has a positive match with all of the regular expressions
        self.X = self._reg_X.match(line)
        self.Y = self._reg_Y.match(line)
        self.Z = self._reg_Z.match(line)
  


if __name__ == '__main__':
    filepath = 'test.txt'
    data = parse(filepath)
    print(data)