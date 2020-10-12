#pragma once

#include <iostream>

bool is_bin(const std::string &str) {
    for (const char &c: str) {
        if (c != '0' && c != '1')
            return false;
    }
    return true;
}

void append_address(std::string* output, const std::string &addr_str) {
    if (addr_str.size() != 8) {
        std::cout<<"Compiler Error: "<<addr_str<<" is not a valid address (8 bits expected)."<<std::endl;
        return;
    }
    if (! is_bin(addr_str)) {
        std::cout<<"Compiler Error: address value "<<addr_str<<" is not a valid binary number."<<std::endl;
        return;
    }
    output->append(addr_str);
}

void append_register_as_binary(std::string* output, const std::string &str) {
    if (str.length() != 2 || str[0] != 'r') {
        std::cout<<"Compiler Error: Wrong register: "<<str<<" r0, r1... expected."<<std::endl;
        return;
    }
    if (str[1] == '0')
        output->append("000");
    else if (str[1] == '1')
        output->append("001");
    else if (str[1] == '2')
        output->append("010");
    else if (str[1] == '3')
        output->append("011");
    else if (str[1] == '4')
        output->append("100");
    else if (str[1] == '5')
        output->append("101");
    else if (str[1] == '6')
        output->append("110");
    else if (str[1] == '7')
        output->append("111");
    else
        std::cout<<"Compiler Error: Wrong register: "<<str<<" r0, r1... expected."<<std::endl;
}

#ifdef UNIT_TEST
#define BOOST_TEST_MODULE example
#include <boost/test/included/unit_test.hpp>
#include <iostream>

std::string int_to_binary_string(size_t integer, size_t nb_bit) {
    std::string output;
    for (size_t i = 1; output.size() < nb_bit; i=i<<1) {
        if (integer & i)
            output.insert (0, 1, '1');
        else
            output.insert (0, 1, '0');
    }
    return output;
}

BOOST_AUTO_TEST_SUITE( ts_compiler ) // Compiler's test suite (ts = Test suite)

BOOST_AUTO_TEST_CASE( tc_int_to_binary_string )
{
  //BOOST_TEST_WARN( sizeof(int) < 4U );
  BOOST_TEST_REQUIRE( "110" == int_to_binary_string(6, 3) );
  BOOST_TEST_REQUIRE( "00000001" == int_to_binary_string(1, 8) );
  BOOST_TEST_REQUIRE( "11111111" == int_to_binary_string(255, 8) );
  BOOST_TEST_REQUIRE( "11011001" == int_to_binary_string(0b11011001, 8) );
  BOOST_TEST_REQUIRE( "" == int_to_binary_string(43, 0) );
}

BOOST_AUTO_TEST_CASE( tc_append_register_as_binary ) // tc = Testcase
{
    std::string output;
    for (size_t i=0; i<=7; i++) {
        std::string a = "r";
        char c = (char)('0'+i); // '0', '1'...
        a.append(&c); // "r0", "r1", ...
        append_register_as_binary(&output, a);
        BOOST_TEST_REQUIRE( output == int_to_binary_string(i, 3) );
        output.clear();
    }
}

BOOST_AUTO_TEST_CASE( tc_is_bin )
{
    BOOST_TEST_REQUIRE( is_bin("00101110101") == true );
    BOOST_TEST_REQUIRE( is_bin("00101210101") == false );
    BOOST_TEST_REQUIRE( is_bin("I0101010101") == false );
    BOOST_TEST_REQUIRE( is_bin("1010101010b") == false );
    BOOST_TEST_REQUIRE( is_bin("") == true );
}

BOOST_AUTO_TEST_CASE( tc_append_address )
{
    std::string output;

    append_address(&output, "01110101");
    BOOST_TEST_REQUIRE( output == "01110101" );
    output.clear();

    std::cout<<"Please ignore compiler's errors:"<<std::endl;
    append_address(&output, "0111010a");
    BOOST_TEST_REQUIRE( output == "" );
    output.clear();

    append_address(&output, "01110102");
    BOOST_TEST_REQUIRE( output == "" );
    output.clear();

    append_address(&output, "a1110101");
    BOOST_TEST_REQUIRE( output == "" );
    output.clear();

    append_address(&output, "21110101");
    BOOST_TEST_REQUIRE( output == "" );
    output.clear();
}

BOOST_AUTO_TEST_SUITE_END()
#endif