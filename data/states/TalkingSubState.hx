import flixel.text.FlxTextAlign;
import flixel.addons.text.FlxTypeText;
import flixel.input.keyboard.FlxKey;

var f:FlxSprite;
var box:FlxSprite;
var face:FunkinSprite;
var text:FlxTypeText;
var textSound:FlxSound;

var theDialog:Int = 0;
var boxVis:Bool = true;
var WMTextVis:Bool = false;
var WMText:FlxText;
var game:ModState;
var bg:FlxSprite;
function create(){
    bg = new FlxSprite().makeGraphic(4000,4000,0xFF000000);
    add(bg);
    bg.scrollFactor.set(0,0);
    bg.alpha = 0.001;
    game = cast FlxG.state;
    // game.members[2].angle += 10;
    theDialog = data.dianumber;
    
    textSound = FlxG.sound.load(Paths.sound("text"));
    f = new FlxSprite();
    add(f);
    box = new FlxSprite(0,0).loadGraphic(Paths.image("sprites/textbox"));
    add(box);
    box.scrollFactor.set(0,0);
    box.screenCenter();
    box.updateHitbox();
    
    box.scale.set(1.8,1.8);
    box.y = FlxG.height - 200;
    

    f.makeGraphic(box.width * 1.8 - 10, box.height * 1.8 - 10, 0xFF140b1a);
    
    f.screenCenter();
    f.scrollFactor.set(0,0);
    f.y = box.y - (box.height / 2) + 20;
    
    face = new FunkinSprite();
    face.frames = Paths.getSparrowAtlas("faces/niko");
    add(face);

    face.scale.set(1.9,1.9);

    face.y = f.y + face.height /2 + 12;
    if(data.dianumber == 2){
        face.loadGraphic(Paths.image("faces/alloy"));
        face.scale.set(2.1,2.1);
        face.y -= 5;
    }
    face.x = 1020;
    face.scrollFactor.set(0,0);
    face.animation.addByPrefix("idle", "idle", 1);
    face.animation.play("idle");
    face.animation.pause();
    text = new FlxTypeText(120,500, 850, "This is a test test... test?" + " " + theDialog, 
    35);
    add(text);
    text.scrollFactor.set(0,0);
    text.font = Paths.font("TerminusTTF-Bold.ttf");
    // text.sounds = [FlxG.sound.load(Paths.sound("text"))];
    // text.start(0.02, true);
    // text.skipKeys = [FlxKey.SPACE];
    WMText = new FlxText(0,0,1000, "placeholder",35);
    WMText.alignment = FlxTextAlign.CENTER;
    add(WMText);
    WMText.scrollFactor.set(0,0);
    WMText.screenCenter();
    theDialogueThing();
    WMText.font = Paths.font("TerminusTTF-Bold.ttf");
    WMText.alpha = 0.001;
    
    if(data.dianumber == 1 || data.dianumber == 2){
        boxVis = false;
        box.alpha = 0.01;
        f.alpha = 0.01;
        face.alpha = 0.01;
        bg.alpha = 0.7;
    }

    
}
var shit = true;
var lastSpace:Bool = false;

var currentDialog:Int = 0;
var doinText:Bool = false;
var name:String = "Player";

//////////////  face, text, pause time, has line break, boxVisible 
var theDialogues = [ 
        [ 
                [0,     "Is this... the inside of the Tower?",                                          0.5,    false,  true],
                [8,     "It's... a lot darker than I thought...",                                       0.5,    false,  true],
                [18,    "...Wait. \nWheres the sun?",                                                   1,      true,   true],
                [8,     "..." + name + "... Do you know what happened to the sun?",                     0.5,    false,  true],
                [8,     "",                                                                             0.5,    false,  false],
                [8,     ".........",                                                                    0,      false,  true],
                [20,    "......" + name + "?",                                                          0,      false,  true],
                ["end"]
        ],
        [
                [-1,    "[Hello, Niko.]"],
                [0,     "H... hello...",                            0.5, false, true],
                [-1, "[Congratulations. You are now inside the Tower.]"],
                [20, "Are you talking......to me, now?", 0.5, false,true],
                [-1, "[Correct.]"],
                [39, "But you were always talking to " + name + " before...", 0.5, false, true],
                [3, "Where's ...", 0.5, false, true],
                [-1,"[" + name + " has already left.]"],
                [-1, "[I had to resort to contacting you directly.]"],
                [20, "Wait, so... " + name + " is gone, just like that?", 0.5, false,true],
                [-1, "[Correct.]"],
                [0, ".... for good?", 0.5,false,true],
                [-1, "[Correct.]"],
                [-1, "[" + name + " has already finished their mission.]"],
                [-1, "[... and so have you, Niko.]"],
                [-2, 0],
                [-1, "[Here, you can rest now.]"],
                [-1, "[Everything that's happened here is like a bad dream.]"],
                [-1, "[When you wake up, you will be home]"],
                [24, "Oh", 0.5,false,true],
                [0, "...", 0.5,false,true],
                [7, "But...", 0.5, false,true],
                [-1, "[What's wrong?]"],
                [8, "I thought there'd be more to it, you know?", 0.5, false,true],
                [0, "I thought... we were supposed to go to the top of the Tower...", 0.5, false,true],
                [3, "I thought here was supposed to be somewhere we need to put the sun in.", 0.5, false,true],
                [7, "And now... I don't even HAVE the sun anymore...", 0.5, false,true],
                [25, "And " + name + " is just... gone...", 0.5, false,true],
                [3, "This feels wrong!", 0.5, false,true],
                [-1, "[But you did good. You saved the world. Niko.]", 0.5, false,true],
                [-1, "[Are you not happy?]"],
                [7, "I guess I am...", 0.5, false,true],
                [6, "But... It's just...", 0.5, false,true],
                [-2, 1],
                [3, "...", 0.5, false,true],
                ["end"]

        ],
        [
                [-1, "And as for you, " + name + "..."],
                [-1, "We're done here."],
                [-1, "Please don't return to this world anymore."],
                [-100, "", 1,false,false],
                [-100, "... ello",1, false,true],
                [-100, "This is just a placeholder", 1, false, true],
                [-100, "I hate dusan nemec", 1, false, true],
                ["end"]
        ]
];
function event(ee){
    switch(ee){
        case 0:
            for(i in 0...game.members.length){
                if(game.members[i].alpha == 0.02){
                    game.members[i].alpha = 1;
                    FlxG.sound.play(Paths.sound("pc_messagebox"));
                    currentDialog += 1;
                    theDialogueThing();
                }
            }
        case 1:
            for(i in 0...game.members.length){
                if(game.members[i].alpha == 0.999){
                    game.members[i].playAnim("off");
                    FlxG.sound.play(Paths.sound("pc_off"), true);
                    currentDialog += 1;
                    theDialogueThing();
                }
            }

    }
}
function theDialogueThing(){

    if(theDialogues[data.dianumber][currentDialog][0] == "end"){
        close();
    }
    if(theDialogues[data.dianumber][currentDialog][0] >= 0 || theDialogues[data.dianumber][currentDialog][0] == -100  ) {    
                textSound.play(true);
    
            WMTextVis = false;
            text.resetText(theDialogues[data.dianumber][currentDialog][1]);
            if(theDialogues[data.dianumber][currentDialog][4] == false){
                boxVis = false;
                new FlxTimer().start(2, function(e:FlxTimer){
                    currentDialog += 1;
                    theDialogueThing();
                });
            } else {
                boxVis = true;
            }
            if(data.dianumber != 2) face.animation.curAnim.curFrame = theDialogues[data.dianumber][currentDialog][0];
            text.start(0.02, true, false, {}, function(){
                doinText = false;
            });
            doinText = true;
    } else {
        trace("ai meu cu");
        WMText.alpha = 0.01;
        WMTextVis = true;
        boxVis = false;
        text.resetText("", true);
        WMText.text = theDialogues[data.dianumber][currentDialog][1];
    }
    if(theDialogues[data.dianumber][currentDialog][0] == -2){
        event(theDialogues[data.dianumber][currentDialog][1]);
        WMText.text = "";
    }
}
function update(){

        WMText.alpha = FlxMath.lerp(WMText.alpha, WMTextVis ? 1 : 0.01, 0.05);
        bg.alpha = WMText.alpha / 1.8;
        box.alpha = FlxMath.lerp(box.alpha, boxVis ? 1 : 0.01, 0.09);
        f.alpha = box.alpha;
        face.alpha = box.alpha;
    if(FlxG.keys.justPressed.SPACE){
        currentDialog += 1;
        theDialogueThing();
    }
    var lastTextThing = text.text.charAt(text.text.length - 1);
    if(lastTextThing == " " && lastSpace == false){
        lastSpace = true;
        textSound.play(true);
    } else if (lastTextThing != " "){
        lastSpace = false;
    }
    if(doinText == true && shit == true && ((text.text.charAt(text.text.length - 1) == "." && text.text.charAt(text.text.length - 2) == "." && text.text.charAt(text.text.length - 3) == ".") || (text.text.charAt(text.text.length - 1) == '\n' && theDialogues[data.dianumber][currentDialog][3] == true))){
        text.paused = true;
        shit = false;
        textSound.play(true);

        new FlxTimer().start(theDialogues[data.dianumber][currentDialog][2], function(ff:FlxTimer){
            text.paused = false;

            new FlxTimer().start(0.1, function(dd:FlxTimer){
                shit = true;
            });
        });
    }
}