import codecs


hex_test = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"

# 010010 010010 0111

# 010010 010010 0111

base64_test = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t\n"

## b64 = codecs.encode(codecs.decode(hex, 'hex'), 'base64').decode()

## print (b64)


def test( hex):
  return codecs.encode(codecs.decode(hex, 'hex'), 'base64').decode()



def hex_to_base64 ( hex): 
    for a in hex:
        print(a)
        var_byte = ""
        if a ==  "0":  var_byte = "0000"   
        if a ==   "1":  var_byte = "0001"   
        if a ==   "2":  var_byte = "0010"   
        if a ==   "3":  var_byte = "0011"   
        if a ==   "4":  var_byte = "0100"   
        if a ==   "5":  var_byte = "0101"   
        if a ==   "6":  var_byte = "0110"   
        if a ==   "7":  var_byte = "0111"   
        if a ==   "8":  var_byte = "1000"   
        if a ==   "9":  var_byte = "1001"   
        if a ==   "a":  var_byte = "1010"   
        if a ==   "b":  var_byte = "1011"   
        if a ==   "c":  var_byte = "1100"   
        if a ==   "d":  var_byte = "1101"   
        if a ==   "e":  var_byte = "1110"   
        if a ==   "f":  var_byte = "1111"   
            

        print(var_byte)


hex_to_base64(hex_test )  

if test(hex_test) == base64_test:
    print ( "all good")
else:
    print (test(hex_test))
    print ( "not so good")




print ( "end")



