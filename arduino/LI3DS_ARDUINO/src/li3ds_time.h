#ifndef __LI3DS_TIME__
#define __LI3DS_TIME__


void time_setup();
void time_loop();
//
void IncrementTime();


// define update rate
#define UPDATE_RATE_1HZ

// 1Hz update rate definitions
#ifdef UPDATE_RATE_1HZ
#define TCNT_BASE 0x0BDC
#define UPDATE_RATE_PER_SECOND 1
#endif

unsigned long old_time;
unsigned long new_time;
//
//char sec[2];
volatile uint8_t t4 = 0;
volatile uint8_t t3 = 0;
volatile uint8_t t2 = 0;
volatile uint8_t t1 = 0;

void time_setup() {
    //--------------------------
    // TIME
    //--------------------------
    old_time = 0;
    new_time = 0;
    //--------------------------
}

#define ROS_DELAY   50  // attente de 50ms dans la phase de temporisation de notre boucle temporelle
                        // => ~ 20Hz

#define PP_TEMPLATE_DECL_NODEHANDLE(_prefix) \
    _prefix<class Hardware,         \
             int MAX_SUBSCRIBERS,   \
             int MAX_PUBLISHERS,    \
             int INPUT_SIZE,        \
             int OUTPUT_SIZE>       \

#define PP_TEMPLATE_INST_NODEHANDLE(_prefix) \
    _prefix<Hardware,           \
            MAX_SUBSCRIBERS,    \
            MAX_PUBLISHERS,     \
            INPUT_SIZE,         \
            OUTPUT_SIZE>        \


PP_TEMPLATE_DECL_NODEHANDLE(template)
void time_loop(PP_TEMPLATE_INST_NODEHANDLE(ros::NodeHandle_) &nh) {
    //----------------------
    // Time: Synchronisation
    //----------------------
    IncrementTime();

    while (millis() - old_time < 1000) {
        //----------------------
        // ROS
        //----------------------
        // Pendant l'attente (temporisation)
        // On continue de faire tourner "la roue" ROS
        // sinon on risque un "Lost device synchronisation ..."
        // car ROS peut considérer trop long l'appel entre deux nh.spinOnce()
        // avec notre temporisition (tous les 1hz)
        nh.spinOnce();
        delay(ROS_DELAY);
        //----------------------
    }
    old_time = millis();
}

/**
 * @brief IncrementTime
 */
void IncrementTime() {
    t1++;
    if (t1 > (UPDATE_RATE_PER_SECOND - 1)) {
        t1 = 0;
        t2++;
    }
    if (t2 > 59) {
        t2 = 0;
        t3++;
    }
    if (t3 > 59) {
        t3 = 0;
        t4++;
    }
    if (t4 > 23) t4 = 0;
}

#endif // __LI3DS_TIME__
