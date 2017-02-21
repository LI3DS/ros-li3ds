#ifndef __LI3DS_PPS__
#define __LI3DS_PPS__

//
volatile uint16_t id_trig = 0;

//
void pps_setup();
void pps_loop();
inline void pps_activate_trig();
inline void pps_desactivate_trig();


//const byte ppsPin = 12;   // montage proto dev
const byte ppsPin = 10;     // montage de Yann


void pps_setup() {
    pinMode(ppsPin, OUTPUT);  // id pin relie au "GPS" vers le VLP (simule le trig)
}

void pps_loop() {
}

inline void pps_activate_trig() {
    digitalWrite(ppsPin, HIGH);
    ++id_trig;
}

inline void pps_desactivate_trig() {
    digitalWrite(ppsPin, LOW);
}

#endif // __LI3DS_PPS__
