

def check_all(array_all, expected):
    if len(array_all) < len(expected):
        print("Error: Output is too short to match expected results")
        return False
    item_i = 0
    while item_i < len(array_all):
        if check_line(array_all[item_i], expected[0]):
            break
        item_i += 1
    print("Detected offset: %d / %d" % (item_i, len(array_all)))
    if len(array_all)-item_i < len(expected):
        print("Error: Output offset to big...")
        return False
    for index in range(len(expected)):
        if not check_line(array_all[item_i+index], expected[index]):
            print("Error at index %d: PC=%s" % (index, array_all[item_i+index]["PC"]))
            return False
    return True


def check_line(result_dic, pattern_dic, verbose=False):
    for key in pattern_dic:
        if pattern_dic[key] == "xx":
            continue
        elif pattern_dic[key][0] == 'z' or result_dic[key][0] == 'z':
            if pattern_dic[key] != result_dic[key]:
                return False
            else:
                continue
        elif key in result_dic and int(result_dic[key], 16) != int(pattern_dic[key], 16):
            if verbose:
                print("%s Error: %s does not match %s" % (key, pattern_dic[key],result_dic[key]))
            return False
    return True


# Use this function to check the design
# Arguments:
# - dic_step: contains dictionnary with values of
#   r0...r7 FE FG FL C and PC registers
# Return:
# - True if et matches the expected values,
#   Else False
non_reset_pc = "ffff"
non_reset_pc_int = 0xffff

def load_csv(filename):
    """
    Load a csv file containning expected result

    it contains:
    r0, ..., r7, FE, FG, FL, C

    values are either 1 byte hexadecimals or xx for
    don't care vales
    """
    output_list = []
    with open(filename) as resfile:
        first_line = resfile.readline().strip()
        keys = first_line.split(",")
        line_count = 0
        for line in resfile:
            line_count += 1
            splitted = line.strip().split(",")
            if splitted==['']:
                continue
            elif len(splitted) != len(keys):
                print("Error in CSV file %s: %s" % (filename, splitted))
                print("splitted is %d, keys are %d" % (len(splitted),len(keys)))
                continue
            line_dic = {}
            for i in range(len(splitted)):
                line_dic[keys[i]] = splitted[i];
            output_list.append(line_dic)

    return output_list[:]
