import java.io.File;

PImage img; //La original
PImage imgmuestra; //La que se muestra, la procesada;

//Resolución de imagenes:
int IMGancho = 640; //Ancho de la imagen
int IMGalto = 480; //Alto de la imagen
/******************/

int guih = 300; //Alto de la interfaz. Ya que el ancho lo obtiene de la resolucion de imagenes
int imagenesguardadas; //Almacena la cantidad de imagenes guardadas

color [] colors = { 
  #18534B, //Color del fondo
  #2C675F, //Color de las lineas

  #2E6E20, //Color por defecto de los botones 
  #48893A, //Color si tiene el mouseencima 
  #94C48A//Color si se clickea,
};

float sep = 50;//Variable para controlar algunas separaciones de los elementos de la interfaz;
float anchobotones = 100;
float altobotones  = 30;

//Botones para guardar y cargar
Bang guardar; 
Bang cargar;

// Un objeto para manejar todos los botoncitos y decidir cual de los botones esta tocado, es basicamente un grupo de botones
ToogleGroup toogles; 

//Variable para setear la cantidad de filtros
int filtercant = 4;

//Un array de grupos de sliders. Dependiendo del filtro activo, dependiendo de cual se muestra.
slidergroup [] slidergroups = new slidergroup[filtercant];

String [] nombrefiltro = new String[filtercant];
float sepyfiltro = 25;
boolean showframe;

void settings() {
  size(IMGancho, IMGalto+guih);
}

void setup() { 

  for (int x=0; x<filtercant; x++) {
    slidergroups[x] = new slidergroup();
  }

  //Inicializar objeto que tiene los toogles:
  toogles = new ToogleGroup();
  //Imagen inicial :
  img = loadImage("grateful-dead.jpg");
  //Este resize con esta imagen no es necesaria pero por las dudas se quiere cambiar la imagen se adapta.
  img.resize(640, 480);
  imagenesguardadas = 0;
  
  //Hacemos una copia para poder guardarla.
  imgmuestra = img.copy();

  colorMode(HSB);
  float tooglesize = 30;
  
  //Agregar toogle al objeto que tiene los toogles
  toogles.addToogle(width*1/3 *1/4, IMGalto+sep*1.5, tooglesize, tooglesize, "1");
  toogles.addToogle(width*1/3 *2.5/4, IMGalto+sep*1.5, tooglesize, tooglesize, "2");
  toogles.addToogle(width*1/3 *1/4, IMGalto+sep*3, tooglesize, tooglesize, "3");
  toogles.addToogle(width*1/3 *2.5/4, IMGalto+sep*3, tooglesize, tooglesize, "4");
  
  
  //Inicializar botones de guardar y cargar
  guardar = new Bang(IMGancho *7/10 + (IMGancho - IMGancho *7/10)/2, IMGalto+sep, anchobotones, altobotones, "Guardar..");
  cargar = new Bang(IMGancho *7/10 + (IMGancho - IMGancho *7/10)/2, IMGalto+sep*2, anchobotones, altobotones, "Cargar..");

  
  //Cambiar colores de botones de guardar y cargar
  guardar.Color_standart = colors[2];
  guardar.Color_mouseover = colors[3];
  guardar.Color_active = colors[4];

  cargar.Color_standart = colors[2];
  cargar.Color_mouseover = colors[3];
  cargar.Color_active = colors[4];

  
  
  float sliderW = 200;
  float sliderH = 25;
  
  //Filtros con sus respectivos nombres :

  nombrefiltro[0] = "Umbral";
  slidergroups[0].addSlider(width/2, IMGalto+sep+sepyfiltro, sliderW, sliderH, 0, 255, 0, "Fuerza ");
  slidergroups[0].addSlider(width/2, IMGalto+sep*2+sepyfiltro, sliderW, sliderH, 0, 255, 50, "Tono");
  slidergroups[0].addSlider(width/2, IMGalto+sep*3+sepyfiltro, sliderW, sliderH, 0, 255, 50, "Saturacion");
  slidergroups[0].addSlider(width/2, IMGalto+sep*4+sepyfiltro, sliderW, sliderH, 0, 255, 50, "Brillo");

  nombrefiltro[1] = "Noise";
  slidergroups[1].addSlider(width/2, IMGalto+sep+sepyfiltro, sliderW, sliderH, 0, 50, 5, "Noise ");

  nombrefiltro[2] = "Vecinos";
  slidergroups[2].addSlider(width/2, IMGalto+sep+sepyfiltro, sliderW, sliderH, 0, 10, 2, "Fuerza brill");
  slidergroups[2].addSlider(width/2, IMGalto+sep*2+sepyfiltro, sliderW, sliderH, 0, 1.5, 1, "Fuerza saturacion");
  slidergroups[2].addSlider(width/2, IMGalto+sep*3+sepyfiltro, sliderW, sliderH, -20, 20, 0, "Fuerza tono");

  nombrefiltro[3] = "Sinuisodal Hue";
  slidergroups[3].addSlider(width/2, IMGalto+sep+sepyfiltro, sliderW, sliderH, 0, 255, 50, "Opacidad ");
  slidergroups[3].addSlider(width/2, IMGalto+sep*2+sepyfiltro, sliderW, sliderH, 0, 10, 5, "Tamaño grilla");
  background(colors[0]);
}

void draw() {

  //---------- INTERFAZ----------------//
  background(colors[0]);
  strokeWeight(10);
  stroke(colors[1], 200);
  line(0, IMGalto, IMGancho, IMGalto);
  line(IMGancho *3/10, IMGalto, IMGancho*3/10, height);
  line(IMGancho *7/10, IMGalto, IMGancho*7/10, height);
  guardar.run();
  cargar.run();
  toogles.run();

  //---------- INTERFAZ----------------//
  
  //SI SE ACTIVA EL BOTON DE GUARDAR
  if (guardar.isActive) {
    PGraphics pg = createGraphics(IMGancho, IMGalto); 
    pg.beginDraw();
    pg.image(imgmuestra, 0, 0); 
    pg.endDraw();
    pg.save("img/imagen"+imagenesguardadas+".jpg"); 
    println("Imagen guardada");
    imagenesguardadas++;
  }
  // SI SE ACTIVA EL BOTON DE CARGAR
  if (cargar.isActive) {
    selectInput("Elegir Imagen", "imagenseleccionada");
  }
  
  //Correr los grupos de sliders (mostrarlos y actualizarlos si se tocan):
  slidergroups[toogles.activetoogle].run();
  
  // Si se toca algun slider de la lista de sliders o se toca algún toogle entonces que se corra la función filtros que es la función que guarda y corre los filtros.
  if (slidergroups[toogles.activetoogle].isSliderPressed() || toogles.change()) {
    filtros(toogles.activetoogle);
  }
  
  
  //Esto es para mostrar el nombre del filtro
  colorMode(HSB);
  textSize(20);
  textAlign(CENTER, CENTER);
  text(nombrefiltro[toogles.activetoogle], width/2, sepyfiltro+IMGalto);

  //Mostrar la imagen original en la esquina inferior derecha
  image(imgmuestra, 0, 0);
  imageMode(CENTER);
  image(img, IMGancho *7/10 + (IMGancho - IMGancho *7/10)/2+5, IMGalto+sep*4, 170, 140);
  imageMode(CORNER);

  //mostrar framerate para visualizar que sucede cuando se toca un efecto.
  if (showframe) {
    textAlign(LEFT);
    text("FRAMERATE :"+frameRate, 10, height-50);
  }
}

void keyPressed() {
  if (key == 'l') {
    selectInput("Elegir Imagen", "imagenseleccionada");
  }
  if (key == 's') {
    PGraphics pg = createGraphics(IMGancho, IMGalto); 
    pg.beginDraw();
    pg.image(imgmuestra, 0, 0); 
    pg.endDraw();
    pg.save("img/imagen"+imagenesguardadas+".jpg"); 
    println("Imagen guardada");
    imagenesguardadas++;
  }
  if ( key == 'f') {
    showframe = !showframe;
  }
  
  
  
}

void filtros(int _filternumber) {
  
  //FUNCION DE LOS FILTROS
  if (_filternumber == 0) {
    
    //toma los valores de los sliders :
    float var1 =  slidergroups[0].sliders.get(0).value;
    float var2 =  slidergroups[0].sliders.get(1).value;
    float var3 =  slidergroups[0].sliders.get(2).value;
    float var4 =  slidergroups[0].sliders.get(3).value;

    float e = random(255);
    for (int x = 0; x < imgmuestra.width; x++) {
      for (int y = 0; y < imgmuestra.height; y++) {
        int loc = x+y*width;

        float hue ;
        float sat ;
        float bri ;
        if (brightness(img.pixels[loc]) <var1 ) {
          hue = var2;
          sat = var3;
          bri = var4;
        } else {
          hue = hue(img.pixels[loc]) ;
          sat = saturation(img.pixels[loc]);
          bri = brightness(img.pixels[loc]);
        }

        imgmuestra.pixels[loc] = color(hue, sat, bri);
      }
    }
    imgmuestra.updatePixels();
  }


  if (_filternumber == 1) {
    
    //toma los valores de los sliders :
    float var1 =  slidergroups[1].sliders.get(0).value;

    colorMode(HSB);
    for (int x = 1; x < imgmuestra.width; x++) {
      for (int y = 1; y < imgmuestra.height; y++) {
        int pos = x+y*width;

        int j = int( constrain(random(x-var1, x+var1), 0, imgmuestra.width-1)) + int(constrain(random(y-var1, y+var1), 0, imgmuestra.height-1)) * width; 

        float hue = hue(img.pixels[pos]) ;
        float sat = saturation(img.pixels[j]);
        float bri = brightness(img.pixels[j]);
        imgmuestra.pixels[pos] = color(hue, sat, bri);
      }
    }

    imgmuestra.updatePixels();
  }

  if (_filternumber == 2) {
    
    //toma los valores de los sliders :
    float var1 =  slidergroups[2].sliders.get(0).value;
    float var2 =  slidergroups[2].sliders.get(1).value;
    float var3 =  slidergroups[2].sliders.get(2).value;

    colorMode(HSB);
    for (int x = 1; x < imgmuestra.width-1; x++) {
      for (int y = 1; y < imgmuestra.height-1; y++) {

       
        //mostrar Matriz de la cual se sacaran el efecto vecinos :
        /*
        __________
         | 4 | 3 | 2 |
         ----------
         | 5 | 0 | 1 |
         ----------
         | 6 | 7 | 8 |
         ----------
         
         */

        int [] pos = new int[9];
        int loc = x+y*width;
        pos[0] = x + y * width;
        pos[1] = (x+1) +   y   * width;
        pos[2] = (x+1) + (y-1) * width;
        pos[3] =   x   + (y-1) *width;
        pos[4] = (x+1) + (y-1) *width;
        pos[5] = (x-1) +   y   *width;
        pos[6] = (x-1) + (y+1) *width;
        pos[7] =   x   + (y+1) *width;
        pos[8] = (x+1) + (y-1) *width;


        float brillosum=0;
        float saturationsum=0;
        float tonosum=0;

        for (int k=0; k<pos.length; k++) {
          brillosum+= brightness(img.pixels[pos[k]]);
          saturationsum+= saturation(img.pixels[pos[k]]);
          tonosum+= hue(img.pixels[pos[k]]);
        }

        brillosum = brillosum/pos.length * var1;
        saturationsum = saturationsum/pos.length * var2;
        tonosum = tonosum/pos.length + var3;

        //float hue = hue(img.pixels[pos[0]]);
        float hue = hue(parseInt(255)) ;
        float sat = saturation(parseInt(saturationsum));
        float bri = brightness(parseInt(brillosum));

        /*float sat = saturation(img.pixels[pos[0]]);
         float bri = brightness(img.pixels[pos[0]]);*/
        imgmuestra.pixels[pos[0]] = color(tonosum, saturationsum, bri);
      }
    }
    imgmuestra.updatePixels();
  }

  if (_filternumber == 3) {
    colorMode(HSB);
    float var1 =  slidergroups[3].sliders.get(0).value;
    float var2 =  slidergroups[3].sliders.get(1).value;
    for (int x = 0; x < imgmuestra.width; x++) {
      for (int y = 0; y < imgmuestra.height; y++) {
        int loc = x+y*width;
        float hue = sin(x*PI*var2/img.width + PI/2 ) * var1 + sin(y*PI*var2/img.height + PI/2) * var1 + hue(img.pixels[loc]) ;
        float sat = saturation(img.pixels[loc]);
        float bri = brightness(img.pixels[loc]);
        imgmuestra.pixels[loc] = color(hue, sat, bri);
      }
    }
    imgmuestra.updatePixels();
  }
}


//Esto es necesario para cargar la imagen :
void imagenseleccionada(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    img = loadImage(selection.getAbsolutePath());
    img.resize(640, 480);
    imgmuestra = img.copy();
    filtros(toogles.activetoogle);
  }
}