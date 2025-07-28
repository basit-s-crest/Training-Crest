def int_to_string(i):
    if i == 0:
        return ""
    else:
        fraq = i % 2
        i = i // 2 
        return int_to_string(i) + str(hex(fraq))

print(int_to_string(123456))