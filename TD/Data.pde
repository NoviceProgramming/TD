int sizeX = 500, sizeY = 650;
boolean mp = false;

GAME game = new GAME();
PREF pref = new PREF();

class GAME {
  int state = 0, buyY2 = 0;
  float camX = 0, camY = 0, camXs = 0, camYs = 0, buyX = 0, buyXs = 0, buyY = 0, buySel = -1;
  //Turret ID + 5 on MapLayout to register. 2-4 are 'undefined'
  int layout[][] = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 1, 1, 1, 1, 5, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 1, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0},
    {0, 0, 0, 0, 1, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 5, 5, 5},
    {0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
  };
  String levelPath[] = "RRRDDDRRDDDRUUUURRRRDDRDDDDDDDDDLLLLLLDDDRRRRRRRRRRRRRR".split("");
  ArrayList<Enemy> enemies;
  ArrayList<Notif> notifs;
  ArrayList<Bullet> bullets;
  STAT stat = new STAT();
}
class STAT {
  int kills = 0;
}
class Enemy {
  int maxhp, maxsh, value, def, progress, distLeft, distTraveled;
  float x, y, hp, sh, sp, HB; //hp- hitpoints, sh-sheild, sp-speed, HB- hitbox
  String type;
  Enemy(float tx, float ty, String ttype){
    progress = 0;
    distLeft = 50;
    distTraveled = 0;
    maxsh = 0;
    def = 0;
    x = tx;
    y = ty;
    type = ttype;
    switch(type){
      case "basic":
        maxhp = 100;
        value = 1;
        sp = 2;
        HB = 14;
      break;
      case "basic2":
        maxhp = 250;
        maxsh = 200;
        value = 5;
        sp = 1;
        HB = 17;
      break;
      case "basic3":
        maxhp = 200;
        maxsh = 400;
        value = 10;
        sp = 1.5;
        HB = 17;
      break;
      case "basic9":
        maxhp = 2500;
        maxsh = 5000;
        value = 100;
        sp = 1;
        HB = 20;
      break;
    }
    hp = maxhp;
    sh = maxsh;
  }
  boolean dead() {
    if(hp <= 0){
      game.stat.kills ++;
      return true;
    }else{
      return false;
    }
  }
  void move(String dir, float amount){
    switch(dir){
      case "R":
        x += amount;
      break;
      case "U":
        y -= amount;
      break;
      case "L":
        x -= amount;
      break;
      case "D":
        y += amount;
      break;
    }
  }
  void display() {
    switch(type){
      case "basic":
        Nellipse(x, y, 20, 20, 8, 3, color(255, 0, 0), 2);
      break;
      case "basic2":
        Nellipse(x, y, 24, 24, 8, 3, color(0, 255, 255), 2);
      break;
      case "basic3":
        Nellipse(x, y, 24, 24, 8, 3, color(0, 255, 0), 2);
      break;
      case "basic9":
        Nellipse(x, y, 34, 34, 8, 3, color(255, 150, 0), 2);
      break;
    }
    fill(255, 0, 0);
    noStroke();
    rect(x, y - 22, hp / maxhp * 20, 3);
    fill(0, 255, 255);
    rect(x, y - 20, sh / maxsh * 20, 3);
    distTraveled += sp;
    distLeft -= sp; //<>//
    if(distLeft < 0){
      move(game.levelPath[progress], distLeft);
      progress ++;
      distLeft = 50;
      distTraveled += distLeft;
      if(progress >= game.levelPath.length){
        progress = 0;
        hp = -1;
        //Take away life?
      }
    }else{
      move(game.levelPath[progress], sp);
    }
  }
  void checkCollision(){
    for(int m = 0; m < game.bullets.size(); m ++){
      Bullet bullet = game.bullets.get(m);
      if(dist(bullet.x, bullet.y, x, y) < HB){
        if(sh > 0){
          sh -= bullet.dmg;
          if(sh < 0){
            sh = 0;
          }
        }else{
          hp -= bullet.dmg;
        }
        bullet.pierce --;
        if(bullet.pierce <= 0){
          game.bullets.remove(m);
        }
      }
    }
  }
}
class Bullet {
  float x, y, a, v, dmg, pierce; //[a]ngle, [v]elocity
  boolean AoE;
  boolean DoT;
  Bullet(float tx, float ty, float ta, float tv, float tdmg, boolean tAoE, boolean tDoT, int tPIR){
    x = tx;
    y = ty;
    a = ta;
    v = tv;
    dmg = tdmg;
    AoE = tAoE;
    DoT = tDoT;
    pierce = tPIR;
  }
  Bullet(float tx, float ty, float ta, float tv, float tdmg, boolean tAoE, boolean tDoT){
    x = tx;
    y = ty;
    a = ta;
    v = tv;
    dmg = tdmg;
    AoE = tAoE;
    DoT = tDoT;
    pierce = 1;
  }
}
class Notif {
  int tl, s, r, g, b;
  float x, y;
  String txt;
  Notif(float Tx, float Ty, int Ts, String Ttxt, int Tr, int Tg, int Tb){
    tl = 250;
    s = Ts;
    r = Tr;
    g = Tg;
    b = Tb;
    x = Tx;
    y = Ty;
    txt = Ttxt;
  }
  boolean requestRemoval() {
    if(tl < 0){
      return true;
    }else{
      return false;
    }
  }
  void display() {
    fill(r, g, b, tl);
    text(txt, x, y);
    y += 2 - tl/50;
    tl -= 5;
  }
}

class PREF {
  float sensitivity = 1;
  int accuracy = 100;
}