#ifndef __LI3DS_CAMLIGHT__
#define __LI3DS_CAMLIGHT__

#include <std_msgs/Empty.h>
#include <std_msgs/String.h>


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
void camlight_setup(PP_TEMPLATE_INST_NODEHANDLE(ros::NodeHandle_) &nh);
void camlight_loop();
//
inline void camlight_trig();
// url: http://wiki.ros.org/rosserial_arduino/Tutorials/Blink
inline void messageCb(const std_msgs::Empty& _);


const byte camPin = 9;

//const byte NB_MAX_LOOP_FOR_CAMLIGHT = 3;  // toute les 3secondes, on enclenche le trig.
//byte nb_loop = 0; // compteur loop pour la camLight

//--------------------------
// Subscriber: 'camlight_trig'
//--------------------------
// Ecoute l'envoi d'un message (vide) qui sert de declencheur
// du trig pinn 9 qui est reliee a la CamLight.
// Ce trig lance (si la CamLight est configuree en mode Trigger)
// la capture d'une image (via le soft 'photo', capture et ecriture asynch.).
//--------------------------
ros::Subscriber<std_msgs::Empty> sub("camlight_trig", &messageCb );
//--------------------------

/**
 * @brief camlight_setup setup du module arduino pour la camlight
 * Utilisation du nodehandler de ROS (pour 1 subscriber)
 */
PP_TEMPLATE_DECL_NODEHANDLE(template)
void camlight_setup(PP_TEMPLATE_INST_NODEHANDLE(ros::NodeHandle_) &nh) {
    //--------------------------
    // CamLight
    //--------------------------
    pinMode(camPin, INPUT);
    digitalWrite(camPin,LOW);

    nh.subscribe(sub);
}

/**
 * @brief camlight_loop rien pour l'instant.
 */
void camlight_loop() {
    //
    // nb_loop ++;
    // if( nb_loop == NB_MAX_LOOP_FOR_CAMLIGHT ) {
    //   // => toute les 3secondes on prendr une image
    //   nb_loop = 0;
    //   //
    //   trigCamLight();
    // }

    // Activation du trig pour une prise de photo
    camlight_trig();
}

/**
 * @brief Activation du tigger pour la CamLight
 * @details simulation d'un bouton (relie a la masse) pour activer le trigger externe
 * de la CamLight.
 */
inline void camlight_trig() {
    //--------------------------
    // Sequence de commandes pour trigger la CamLight
    //--------------------------
    pinMode(camPin, OUTPUT);
    digitalWrite(camPin,LOW);
    delay(1); // 1ms d'appui sur le bouton.
    pinMode(camPin, INPUT);
    digitalWrite(camPin,LOW);
    //--------------------------
}

/**
 * @brief methode callback sur une reception de message std_msgs::Empty
 * @details callback sur le trig cote ROS vers arduino pour l'activation du trig
 * de la CamLight
 *
 * @param _
 */
inline void messageCb(const std_msgs::Empty& _)
{
    camlight_trig();
}

#endif // __LI3DS_CAMLIGHT__
