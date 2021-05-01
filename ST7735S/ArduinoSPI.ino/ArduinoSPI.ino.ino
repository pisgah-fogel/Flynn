#include <SPI.h>

#define SCLK 13 // Default Arduino UNO port
#define MOSI 11 // Default Arduino UNO port
#define CS   9
#define DC   10 
#define RESET 8

void setup() {
  Serial.begin(9600);
  SPI.begin();
  pinMode(DC, OUTPUT);
  pinMode(RESET, OUTPUT);
  pinMode(CS, OUTPUT);

  digitalWrite(DC, LOW);
  digitalWrite(RESET, LOW);
  digitalWrite(CS, HIGH);

  delay(500);
  digitalWrite(RESET, HIGH);
  delay(500);

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0x01); // Software reset p.108
  digitalWrite(CS, HIGH);
  delay(18); // Wait at least 120ms

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0x11); // Sleep Out & Booster On p.105
  digitalWrite(CS, HIGH);
  delay(18); // Wait at least 120ms

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0xb1); // FRMCTR1 (B1h): Frame Rate Control (In normal mode/ Full colors) p159
  digitalWrite(DC, HIGH);
  SPI.transfer(0x01); // Parameter 1: RTNA
  SPI.transfer(0x2c); // Parameter 2: FPA
  SPI.transfer(0x2d); // Parameter 3: BPA
  digitalWrite(CS, HIGH);

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0xb2); // FRMCTR2 (B2h): Frame Rate Control (In Idle mode/ 8-colors)
  digitalWrite(DC, HIGH);
  SPI.transfer(0x01); // Parameter 1: RTNA
  SPI.transfer(0x2c); // Parameter 2: FPA
  SPI.transfer(0x2d); // Parameter 3: BPA
  digitalWrite(CS, HIGH);

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0xb3); // FRMCTR3 (B3h): Frame Rate Control (In Partial mode/ full colors)
  digitalWrite(DC, HIGH);
  SPI.transfer(0x01); // Parameter 1: RTNA
  SPI.transfer(0x2c); // Parameter 2: FPA
  SPI.transfer(0x2d); // Parameter 3: BPA
  SPI.transfer(0x01); // Parameter 4: RTNA
  SPI.transfer(0x2c); // Parameter 5: FPA
  SPI.transfer(0x2d); // Parameter 6: BPA
  digitalWrite(CS, HIGH);

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0xc0); // PWCTR1 (C0h): Power Control 1
  digitalWrite(DC, HIGH);
  SPI.transfer(0xa2); // Parameter 1: TODO
  SPI.transfer(0x02); // Parameter 2: TODO
  SPI.transfer(0x84); // Parameter 3: TODO
  digitalWrite(CS, HIGH);

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0xc1); // PWCTR2 (C1h): Power Control 2
  digitalWrite(DC, HIGH);
  SPI.transfer(0xc5); // Parameter 1:
  digitalWrite(CS, HIGH);

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0xc2); // PWCTR3 (C2h): Power Control 3 (in Normal mode/ Full colors) 
  digitalWrite(DC, HIGH);
  SPI.transfer(0x0a); // Parameter 1:
  SPI.transfer(0x00); // Parameter 2:
  digitalWrite(CS, HIGH);

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0xc3); // PWCTR4 (C3h): Power Control 4 (in Idle mode/ 8-colors) 
  digitalWrite(DC, HIGH);
  SPI.transfer(0x8a); // Parameter 1:
  SPI.transfer(0x2a); // Parameter 2:
  digitalWrite(CS, HIGH);

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0xc4); // PWCTR5 (C4h): Power Control 5 (in Partial mode/ full-colors)
  digitalWrite(DC, HIGH);
  SPI.transfer(0x8a); // Parameter 1:
  SPI.transfer(0xee); // Parameter 2:
  digitalWrite(CS, HIGH);

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0xc5); // VMCTR1 (C5h): VCOM Control 1 
  digitalWrite(DC, HIGH);
  SPI.transfer(0x0e); // Parameter 1:
  digitalWrite(CS, HIGH);

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0x36); // MADCTL (36h): Memory Data Access Control p.142
  digitalWrite(DC, HIGH);
  SPI.transfer(0xc8); // Parameter 1:
  digitalWrite(CS, HIGH);

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0x3a); // COLMOD (3Ah): Interface Pixel Format
  digitalWrite(DC, HIGH);
  SPI.transfer(0x05); // Parameter 1: 16-bit/pixel
  digitalWrite(CS, HIGH);

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0x2a); // CASET (2Ah): Column Address Set
  digitalWrite(DC, HIGH);
  SPI.transfer(0x00); // Parameter 1: XS MSB
  SPI.transfer(0x00); // Parameter 1: XS LSB
  SPI.transfer(0x00); // Parameter 1: XE MSB
  SPI.transfer(0x7f); // Parameter 1: XE LSB
  digitalWrite(CS, HIGH);

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0x2b); //  RASET (2Bh): Row Address Set
  digitalWrite(DC, HIGH);
  SPI.transfer(0x00); // Parameter 1: YS MSB
  SPI.transfer(0x00); // Parameter 1: YS LSB
  SPI.transfer(0x00); // Parameter 1: YE MSB
  SPI.transfer(0x9f); // Parameter 1: YE LSB
  digitalWrite(CS, HIGH);

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0xe0); //  GMCTRP1 (E0h): Gamma (‘+’polarity) Correction Characteristics Setting
  digitalWrite(DC, HIGH);
  SPI.transfer(0x02);
  SPI.transfer(0x1c);
  SPI.transfer(0x07);
  SPI.transfer(0x12);
  SPI.transfer(0x37);
  SPI.transfer(0x32);
  SPI.transfer(0x29);
  SPI.transfer(0x2d);
  SPI.transfer(0x29);
  SPI.transfer(0x25);
  SPI.transfer(0x2b);
  SPI.transfer(0x39);
  SPI.transfer(0x00);
  SPI.transfer(0x01);
  SPI.transfer(0x03);
  SPI.transfer(0x10);
  digitalWrite(CS, HIGH);

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0xe1); //  GMCTRN1 (E1h): Gamma ‘-’polarity Correction Characteristics Setting
  digitalWrite(DC, HIGH);
  SPI.transfer(0x03);
  SPI.transfer(0x1d);
  SPI.transfer(0x07);
  SPI.transfer(0x06);
  SPI.transfer(0x2e);
  SPI.transfer(0x2c);
  SPI.transfer(0x29);
  SPI.transfer(0x2d);
  SPI.transfer(0x2e);
  SPI.transfer(0x2e);
  SPI.transfer(0x37);
  SPI.transfer(0x3f);
  SPI.transfer(0x00);
  SPI.transfer(0x00);
  SPI.transfer(0x02);
  SPI.transfer(0x10);
  digitalWrite(CS, HIGH);

  // TODO: Useless because set by default ?
  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0x13); //  NORON (13h): Normal Display Mode On
  digitalWrite(CS, HIGH);

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0x29); //  DISPON (29h): Display On
  digitalWrite(CS, HIGH);

  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0x36); //  0x36 - MADCTL (36h): Memory Data Access Control p.142
  digitalWrite(DC, HIGH);
  SPI.transfer(0xc0);
  digitalWrite(CS, HIGH);
  // TODO: repeat it twice ?

  // Draw on screen
  digitalWrite(DC, LOW);
  digitalWrite(CS, LOW);
  SPI.transfer(0x2a); // CASET (2Ah): Column Address Set
  digitalWrite(DC, HIGH);
  SPI.transfer(0x00); // Parameter 1: XS MSB
  SPI.transfer(0x00); // Parameter 1: XS LSB
  SPI.transfer(0x00); // Parameter 1: XE MSB
  SPI.transfer(0x7f); // Parameter 1: XE LSB
  digitalWrite(DC, LOW);
  SPI.transfer(0x2b); //  RASET (2Bh): Row Address Set
  digitalWrite(DC, HIGH);
  SPI.transfer(0x00); // Parameter 1: YS MSB
  SPI.transfer(0x00); // Parameter 1: YS LSB
  SPI.transfer(0x00); // Parameter 1: YE MSB
  SPI.transfer(0x9f); // Parameter 1: YE LSB
  digitalWrite(DC, LOW);
  SPI.transfer(0x2c); //  RAMWR (2Ch): Memory Write p.132 GM='11'
  digitalWrite(DC, HIGH);
  for(size_t i = 0; i<128*160; i++) {
    // 0bRRRR RGGG GGGB BBBB
    SPI.transfer(0xf8);
    SPI.transfer(0x00);
  }
  digitalWrite(CS, HIGH);
  digitalWrite(DC, LOW);
}

void loop() {
  Serial.println("Test");
  delay(2000);
}
