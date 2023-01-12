import processing.io.*;

// LEDをオン・オフする際の出力
int DIGIT_ON  = GPIO.LOW;
int DIGIT_OFF = GPIO.HIGH;
int SEGMENT_ON = GPIO.HIGH;
int SEGMENT_OFF = GPIO.LOW;

int digitPins[] = {7, 9, 10, 13};                                        // ディジット(コモン)に接続するArduinoのピン
int segmentPins[] = {12, 8, 5, 3, 2, 11, 6};                             // セグメントピンに接続するArduinoのピン
int numberOfDigitPins = 4;        // ディジットの数
int numberOfSegmentPins = 7;  // セグメントの数

// 数字と表示させるセグメントの関係
int digits[] = {
    0b00111111,  // 0
    0b00000110,  // 1
    0b01011011,  // 2
    0b01001111,  // 3
    0b01100110,  // 4
    0b01101101,  // 5
    0b01111101,  // 6
    0b00100111,  // 7
    0b01111111,  // 8
    0b01101111,  // 9
};

// 数字を表示する
void displayNumber(int n) {
  // digits[n]の各ビットを調べて対応するセグメントを点灯・消灯する
  for (int i = 0; i < numberOfSegmentPins; i++) {
     GPIO.digitalWrite(segmentPins[i], (digits[n] & (1 << i)) == 1 ? SEGMENT_ON : SEGMENT_OFF);
  }
}

// セグメントをすべてオフにする
void clearSegments() {
  for (int j = 0; j < numberOfSegmentPins; j++) {
    GPIO.digitalWrite(segmentPins[j], SEGMENT_OFF);
  }
}

// 4桁の数字を表示する
void displayNumbers(int n) {
  for (int i = 0; i < numberOfDigitPins; i++) {  // 右の桁からディジットを選択する
    GPIO.digitalWrite(digitPins[i], DIGIT_ON);        // ディジットをオンにする
    displayNumber(n % 10);                       // 10で割った余りを求めて、1の位を求め、表示する
    delay(1);
    clearSegments();                        // セグメントをすべてオフにする
    GPIO.digitalWrite(digitPins[i], DIGIT_OFF);  // ディジットをオフにする
    n /= 10;                                // 10で割り、次に表示する数字を、1の位に移す
  }
}

// setup()　は，最初に一度だけ実行される
void setup() {
  for (int i = 0; i < numberOfDigitPins; i++) {
    GPIO.pinMode(digitPins[i], GPIO.OUTPUT);  // digitPinsを出力モードに設定する
    GPIO.digitalWrite(digitPins[i], DIGIT_OFF);
  }
  for (int i = 0; i < numberOfSegmentPins; i++) {
    GPIO.pinMode(segmentPins[i], GPIO.OUTPUT);  // segmentPinsを出力モードに設定する
  }
}

void loop() {
  for (int i = 0; i < 10000; i++) {  // 0から9999までを表示する。
    displayNumbers(i);
  }
}
