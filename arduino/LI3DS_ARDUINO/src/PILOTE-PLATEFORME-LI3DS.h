#ifndef __PILOTE_PLATEFORME_LI3DS__
#define __PILOTE_PLATEFORME_LI3DS__

#define DEBUG_MSG
//#define USED_BUZZER

// Interpreteur
#define START_STOP         "s"
#define PAUSE_NOPAUSE      "p"
#define FLASH_ONOFF        "f"
#define CONFIG_MODE        "c={"   // c={VAR1=var1value|VAR2=var2value...}

#define BAUD_RATE          (57600)
#define BAUD_RATE_VAR      "BAUD_RATE"
#define INPUTSTRING_SIZE   (40)
#define OUTPUTSTRING_SIZE  (20)

// definition des ports.
//
#define FLASH_PIN           11     //sortie pwm eclairage
#define CAM_PIN             9     //sortie commande photo aux cameras (toujours LOW, mais INPUT pour haute impedance et OUTPUT pour mettre a la masse)
//#define STARTCAM_PIN        4     //entree debut serie de photos
//#define READYCAM_PIN        5     //Cam prête
#define RUN_LED             6     //run arduino

#ifdef USED_BUZZER
    #define BUZZER_PIN      5      //buzzer
#endif

// definitions flash 
#define MAX_FLASHLEVEL        255      // Niveau eclairement max (ie flash).
#define MIN_FLASHLEVEL        5        // Niveau eclairement eco.
#define FLASH_OFFLEVEL        0        // default FLASH ON.
#define STAB_FLASH_DELAY      2
#define FLASH_DELAY          10       // Extinction du flash apres prise de photo.


// definitions cam
#define TIME_ACQUISITION_VAR      "TIME_ACQUISITION"   // Temps acquisition photo.
#define CAM_WRITE_DELAY      1                         // delay apres ecriture sur pin de camlight

#ifdef USED_BUZZER
    
    #define BUZZER_ON       255      // Buzzer on .
    #define BUZZER_OFF      0        // buzzer off.
#endif

// Serial
unsigned int baud_rate = BAUD_RATE;
String inputString = String("");        // a string to hold incoming data.
String outputString = String("");       // A string to hold IS+TimeStamp of current pics
boolean stringComplete = false;         // whether the string is complete.


// Cam & pics
int num_pics;                           // number of pics.
unsigned long prevShot_ms;              // prev time pics in ms.
unsigned long currentShot_ms ;          // current time pics in ms.
unsigned long beginWork_ms ;            // debut chantier en ms
unsigned int time_acquisition_delay=15; // Time acquisition of a photo. This value is embedded on SD card

unsigned int time_between_pics=900;    // Time between two pics in ms.
unsigned int delay_correction=time_acquisition_delay+FLASH_DELAY+STAB_FLASH_DELAY+CAM_WRITE_DELAY;  // correction des temps pour obtenir un intervalle de temps entre photos correct
unsigned int time_between_pics_revised=time_between_pics-delay_correction ;   // temps corrigé



// states
boolean start_state ;
boolean pause_state ;
boolean flash_state ;


void initSerial() {
 String msg = String("") ;
 
  inputString.reserve(INPUTSTRING_SIZE) ;
  outputString.reserve(OUTPUTSTRING_SIZE) ;
  
  //Initialize serial and wait for port to open:
  Serial.begin(baud_rate) ;
  while (!Serial) { ; }
  msg="Serial communication ready at "+String(baud_rate)+" baud!" ;
  Serial.println(msg) ;
  return ;
}

void configurePorts() {
  pinMode(FLASH_PIN, OUTPUT);
  pinMode(CAM_PIN, INPUT);
  //pinMode(STARTCAM_PIN, INPUT);
  pinMode(RUN_LED, OUTPUT);
#ifdef USED_BUZZER
  pinMode(BUZZER_PIN, OUTPUT);
#endif
  return ;
}

void serialEvent() {
  while (Serial.available()) {
    char inChar = (char)Serial.read();                   //get new byte
    if (inChar != '\n') { inputString += inChar; }       // TODO warn not ctr sur lenght
    else { stringComplete = true; }
  }
  return ;
}

void parseConfig(String is) {
  String msg = String("") ;
  String temp = String("");
  int index=0;
   while( is.length()!=0 ) {
      index=is.indexOf("|") ;
      if(index==-1) {
          temp=is.substring(0,is.length()) ;
          is="" ;
      }
      else {
          temp=is.substring(0, index) ;
          is=is.substring(index+1,is.length()) ;
      }
#ifdef DEBUG_MSG
      msg="temp=["+temp+"]" ;
      Serial.println(msg) ;
      msg="is=["+is+"]" ;
      Serial.println(msg) ;
#endif
      if( temp.substring( 0,temp.indexOf("=") )==BAUD_RATE_VAR) {
         baud_rate=temp.substring(temp.indexOf("=")+1, temp.length()).toInt() ;
      }
      else if (temp.substring(0,temp.indexOf("="))==TIME_ACQUISITION_VAR) {
         time_acquisition_delay=temp.substring( temp.indexOf("=")+1, temp.length()).toInt() ;
      }
      else {
      msg="WARNING: "+temp.substring( 0,temp.indexOf("="))+" variable unknown!" ;
      Serial.println(msg) ; 
      }
   }
  return ;
}


void toggleSTART() {
  String msg = String("");
 
    if(start_state) {
        num_pics=0;                         // init number of pics.
        prevShot_ms=millis();               // init current time pics in ms.
        beginWork_ms=prevShot_ms ;
        currentShot_ms=0; 
       msg=String("BEGIN-")+String(0)+"HH:"+String(0)+"MM:"+String(0)+"SS";
    }
    else {
      unsigned long duration=millis()-beginWork_ms ;
      Serial.println ( duration ) ;
      int hh=floor( (duration/3600000) ) ;
      int mm=floor( ((duration-(3600000*hh))/60000) );
      int ss=floor( ( (duration-(3600000*hh)-(60000*mm))/1000)) ;
      beginWork_ms=0;
      msg=String("END-")+String(hh)+"HH:"+String(mm)+"MM:"+String(ss)+"SS";
    }
    Serial.println ( msg );  
    //Serial.println ( (start_state==true?  "START On":"START Off") );
    return ;
}

void togglePAUSE() {
    
    Serial.println ( (pause_state==true?  "PAUSE On":"PAUSE Off") );
    return ;
}


void toggleFLASH() {
  analogWrite(FLASH_PIN, (flash_state==true? MIN_FLASHLEVEL : FLASH_OFFLEVEL) );
  delay(STAB_FLASH_DELAY); 
  time_between_pics_revised=time_between_pics-(flash_state==true? time_acquisition_delay+FLASH_DELAY+STAB_FLASH_DELAY+CAM_WRITE_DELAY: time_acquisition_delay+CAM_WRITE_DELAY);
  Serial.println ( (flash_state==true?  "FLASH On":"FLASH Off") ); 
  return ;
}


void execCommand() {
    if (inputString==START_STOP) { 
        if(!pause_state) { 
            start_state=!start_state;
            toggleSTART() ;
        }
        else { 
            Serial.println ("Can't START On/Off, System PAUSE ON");
        }
    }
    else if (inputString==PAUSE_NOPAUSE) {
        if (start_state) { 
          pause_state=!pause_state; 
          togglePAUSE();
        }
        else { 
          Serial.println ("Can't PAUSE On/Off, System STOPPED");
        }
    }
    else if (inputString==FLASH_ONOFF) {
        flash_state=!flash_state ;
        toggleFLASH(); 
    }
    else if (inputString.startsWith(CONFIG_MODE)&&inputString.endsWith("}") ) {
        String is = String("");
        int from = inputString.indexOf("{")+1 ;
        int to = inputString.length()-1;
        Serial.println ("Enter config mode") ;
        is=inputString.substring(from, to) ;
        parseConfig(is) ;
    }
    else { 
        String msg ="WARNING: "+inputString+" Unknown command.";
        Serial.println(msg) ;
    } 
    inputString="";
    stringComplete=false ;
    return ;
}


void take_pic() { 
 if(flash_state) {                                     
    analogWrite(FLASH_PIN, MAX_FLASHLEVEL);
    delay(STAB_FLASH_DELAY);                           // on attend la stabilisation de l'eclairage à sa valeur max.
 }

#ifdef USED_BUZZER
 // start buzzer.
 analogWrite(BUZZER_PIN, BUZZER_ON);  
#endif
    
  pinMode(CAM_PIN, OUTPUT);
  digitalWrite(CAM_PIN,LOW);
  
  delay(CAM_WRITE_DELAY);                                     //1ms
  
  pinMode(CAM_PIN, INPUT);
  digitalWrite(CAM_PIN,LOW);
  
  currentShot_ms=millis();
  num_pics++;
  if(flash_state) {
      delay(time_acquisition_delay+FLASH_DELAY);      // attente de : temps acquisition de la prise de photo+ delais constant de 10ms avant de 
                                                      // couper les LED. 
                                                     
       analogWrite(FLASH_PIN, MIN_FLASHLEVEL);     //Led niveau bas
  }     

#ifdef DEBUG_MSG
//  Serial.print("Pics number [") ;
//  Serial.print(num_pics) ;
//  Serial.print("-") ;
//  Serial.print(lastShot_ms) ;
//  Serial.println("]") ;
#endif  
  
#ifdef USED_BUZZER
  //stop buzzer
  anogWrite(BUZZER_PIN, BUZZER_OFF);
#endif
   long delta = currentShot_ms-prevShot_ms ;
   outputString=String(num_pics)+"-"+String(currentShot_ms)+"-"+String(delta) ; 
   Serial.println(outputString) ;
   outputString="";
   prevShot_ms=currentShot_ms;
   
  return ;
}


void setup_plateforme() {
  initSerial();
  configurePorts();
  start_state=false;           // stat run, ie take pics
  pause_state=false;           // stat pause, false
  flash_state=true;            // flash activate
  analogWrite(FLASH_PIN, MIN_FLASHLEVEL);     //Led niveau bas
  return ;
}

void loop_plateforme() {
  if (stringComplete) { execCommand(); }
  if(!pause_state && start_state) {  take_pic(); }
  delay(time_between_pics_revised) ;                // Temps entre deux photos corrigé du temps passé dans la fonction take_pics().

}

#endif
