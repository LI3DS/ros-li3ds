#ifndef __LI3DS_GPS__
#define __LI3DS_GPS__


#include "li3ds_time.h"


void gps_setup();
void gps_loop();
//
const String generateSentenceNMEA();
char checkSum(String theseChars);


SoftwareSerial gps(10, 4, true); // RX, TX, inverse_logic

char gprmc[96];
char check;

void gps_setup() {
    // Init Serial communication
    //--------------------------
    // Serial.begin(9600);  // pertube la communication ROSSERIAL
    gps.begin(9600);
    //--------------------------
}

void gps_loop() {
    //---------------------------------
    // NMEA Sentence: Building
    //---------------------------------
    const String& str = generateSentenceNMEA();
    gps.print(str);
    // Serial.println(str);
    //---------------------------------
}

/**
 * @brief generateSentenceNMEA
 * @return
 */
const String generateSentenceNMEA()
{
    //gps.write("$GPRMC,220516,A,5133.82,N,00042.24,W,173.8,231.8,130694,004.2,W*70\r");  // OK
    sprintf(gprmc,
            "GPRMC,%2.2u%2.2u%2.2u,A,4901.00,N,200.00,W,0.1,180,01012016,,,S", t4, t3, t2
            );

    String str(gprmc);
    check = checkSum(str);
    String s_check(check, HEX);
    //
    str = '$' + str + '*' + s_check;
    str += '\r';

    return str;
}

/**
 * @brief checkSum
 * @param theseChars
 * @return
 */
char checkSum(String theseChars) {
    char check = 0;
    // iterate over the string, XOR each byte with the total sum:
    for (int c = 0; c < theseChars.length(); c++) {
        check = char(check ^ theseChars.charAt(c));
    }
    // return the result
    return check;
}

#endif // __LI3DS_GPS__
