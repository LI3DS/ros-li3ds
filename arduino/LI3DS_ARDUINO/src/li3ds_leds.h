#ifndef __LI3DS_CAMLIGHT__
#define __LI3DS_CAMLIGHT__

#include <std_msgs/Empty.h>
#include <std_msgs/String.h>


// ------------------------------------------------------------------------------------------

#include "PILOTE-PLATEFORME-LI3DS.h"

// ------------------------------------------------------------------------------------------

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
void led_setup(PP_TEMPLATE_INST_NODEHANDLE(ros::NodeHandle_) &nh);
void led_loop();
//
inline void led_trig();
// url: http://wiki.ros.org/rosserial_arduino/Tutorials/Blink
inline void messageCb(const std_msgs::Empty& _);


//--------------------------
// Subscriber: 'led_trig'
//--------------------------
// Ecoute l'envoi d'un message (vide) qui sert de declencheur
// du trig pin 11 qui est reliee aux leds.
//--------------------------
ros::Subscriber<std_msgs::Empty> sub("led_trig", &messageCb );
//--------------------------

/**
 * @brief led_setup setup du module arduino pour la gestion des leds
 * Utilisation du nodehandler de ROS (pour 1 subscriber)
 */
PP_TEMPLATE_DECL_NODEHANDLE(template)
void led_setup(PP_TEMPLATE_INST_NODEHANDLE(ros::NodeHandle_) &nh) {
    //--------------------------
    // LEDs
    //--------------------------
    configurePorts();

    start_state=false;           // stat run, ie take pics
    pause_state=false;           // stat pause, false
    flash_state=true;            // flash activate
    analogWrite(FLASH_PIN, MIN_FLASHLEVEL);     //Led niveau bas

    //--------------------------
    // ROS
    //--------------------------
    nh.subscribe(sub);
}


/**
 * @brief camlight_loop rien pour l'instant.
 */
void led_loop() {
    if(!pause_state && start_state) {  
        take_pic(); 
    }
}

/**
 * @param _
 */
inline void messageCb(const std_msgs::Empty& _)
{
    if(!pause_state) { 
        start_state = !start_state;
        toggleSTART() ;
    }
    else { 
        // Serial.println ("Can't START On/Off, System PAUSE ON");
    }
}

#endif // __LI3DS_CAMLIGHT__
