import flixel.FlxObject;
import funkin.menus.ModSwitchMenu;
import funkin.backend.utils.DiscordUtil;

var niko:FunkinSprite;
var stepSounds:Array = [];
var computer:FunkinSprite;
var computerHB:FlxSprite;
var tiles:Array;
var tileShit:Array = [5];
var nikoLook:FlxSprite;
var canWalk:Bool = true;
var initializedthis:Bool = false;
var bed:FunkinSprite;
var bedHB:FlxSprite;
var cutscene:Array = [];
var skipcutscene = false;
var goingtoSleep = false;

function create(){
		DiscordUtil.call("onMenuLoaded", ["Main Menu"]);
        DiscordUtil.changePresence("OneShot", "Tower", null);
    FlxG.sound.playMusic(Paths.music("Distant"));
    FlxG.sound.music.pitch = 0.55;
    for(i in [1,2,3,5,6]){
        var thing:FlxSound = FlxG.sound.load(Paths.sound("step_splash" + i));
        stepSounds.push(thing);
        thing.pitch = 1.05;
    }

    computer = new FunkinSprite();
    computer.frames = Paths.getSparrowAtlas("sprites/computer");
    computer.animation.addByPrefix("idle", "idle", 1, true);
    computer.animation.addByPrefix("off", "off", 1, true);
    computer.playAnim("idle");
    add(computer);
    computer.x = -500;
    computer.scale.set(4,4);
    computer.updateHitbox();
    computer.immovable = true;
    // computer.alpha = 0.999;
    computerHB = new FlxSprite(computer.x, computer.y).makeGraphic(computer.width, computer.height + 40,0x00FFFFFF);
    add(computerHB);

    bed = new FunkinSprite(-350, 70);
    bed.frames = Paths.getSparrowAtlas("sprites/bed");
    add(bed);
    for(asd in ["1", "2", "3"]){
        bed.animation.addByPrefix(asd, asd, 1, false);
    }
    bed.playAnim("1");
    bed.scale.set(2,2);
    bed.updateHitbox();
    bedHB = new FlxSprite(bed.x + 80,bed.y+15).makeGraphic(bed.width / 1.6, bed.height - 10, 0x00FFFFFF);
    add(bedHB);
    bed.alpha = 0.02;
    niko = new FunkinSprite(600,0);
    niko.frames = Paths.getSparrowAtlas("sprites/niko");
    
    add(niko);
        niko.animation.addByPrefix("idle0", "idle", 6, true);
        niko.animation.addByPrefix("idleup", "idleup", 6, true);
        niko.animation.addByPrefix("idleright", "idleright", 6, true);
        niko.animation.addByPrefix("idleleft", "idleleft", 6, true);

        niko.animation.addByPrefix("down", "down", 6, true);
        niko.animation.addByPrefix("left", "left", 6, true);
        niko.animation.addByPrefix("right", "right", 6, true);
        niko.animation.addByPrefix("up", "up", 6, true);

        
        niko.animation.addByPrefix("rundown", "down", 8, true);
        niko.animation.addByPrefix("runleft", "left", 8, true);
        niko.animation.addByPrefix("runright", "right", 8, true);
        niko.animation.addByPrefix("runup", "up", 8, true);
        for(i in [niko] ){
        i.scale.set(2,2);
        }
    niko.updateHitbox();
    
    nikoHB = new FlxSprite().makeGraphic(niko.width / 1.5, niko.height / 4, 0x00FFFFFF);
    add(nikoHB);
    
    nikoLook = new FlxSprite().makeGraphic(10,10, 0x00FFFFFF);
    add(nikoLook);

    FlxG.camera.follow(niko, FlxCamera.STYLE_PLATFORMER);

    niko.moves = false;
    computerHB.scrollFactor.set(1,1);
    niko.scrollFactor.set(1,1);

    for(i in [1,2,3,4,5]){
        var cg = new FlxSprite().loadGraphic(Paths.image("cg_tower" + i));
        cg.scrollFactor.set(0,0);
        add(cg);
        cg.setGraphicSize(0, FlxG.height);
        cg.updateHitbox();
        cg.screenCenter();
        cg.alpha = 0.001;
        cutscene.push(cg);
    }    
    canWalk = false;
    if(skipcutscene == false) {
        cutscene[0].alpha = 1; cuts();
    
    } 
    if (skipcutscene == true) { 
            new FlxTimer().start(1,function(ee:FlxTimer){openSubState(new ModSubState("TalkingSubState", {dianumber: 0})); niko.moves = true; canWalk = false; initializedthis = true;});

    }

    // canWalk = true;
    // niko.moves = true;
    // initializedthis = true;
    computer.ID = 300;
    bed.ID = 400;
}
var curCut = 0;
public function testHit(){
    niko.angle += 100;
}
function cuts(){
    if(curCut <= cutscene.length - 1){
        FlxTween.tween(cutscene[curCut], {alpha:1}, 1, {onComplete: function(){ curCut += 1; new FlxTimer().start(2, function(dd:FlxTimer){ cuts();}); }});
    }
    if(curCut >= cutscene.length){
        for(i in 0...4){
            cutscene[i].alpha = 0.001;
        }
        FlxTween.tween(cutscene[curCut - 1], {alpha: 0.001}, 1, {onComplete:function(){
            new FlxTimer().start(1,function(ee:FlxTimer){openSubState(new ModSubState("TalkingSubState", {dianumber: 0})); niko.moves = true; canWalk = false; initializedthis = true;});
        }});
    }
}
var lastPressed:Int = 0;
var playingStep:Bool = false;

var _time:Float = 0;
var currentStepSound = 0;
var running:Bool = false;
function updateLookShit(){
    switch(lastPressed){
        case 1:
            nikoLook.x = niko.x;
            nikoLook.y = niko.y + (niko.height /2 ) + 10;

        case 2: 
            nikoLook.x = niko.x + 0 + (niko.width) -10;
            nikoLook.y = niko.y + (niko.height /2 ) + 10;
        case 3:
            nikoLook.x = niko.x + (niko.width / 2) - 5;
            nikoLook.y = niko.y + 50;
        case 4,0:
            nikoLook.x = niko.x + (niko.width /2) - 5;
            nikoLook.y = niko.y + 130;
    }
    nikoHB.setPosition(niko.x + (niko.width / 2 - nikoHB.width / 2),niko.y +80);
    niko.scrollFactor.set(1,1);
}
var shit = [];
var stepsff = 0;
var speeds = [200,350];

function stepTHing(){
    // private var splash = new FlxSprite().loadGraphic(Paths.image("drawers"));
    private var splash = new FunkinSprite();
    splash.frames = Paths.getSparrowAtlas("sprites/splash");
    splash.animation.addByPrefix("idle", "idle", 8, false, true);
    splash.playAnim("idle");
    splash.scale.set(4,4);
    splash.alpha = 1;
    // splash.x = niko.x;
    // switch(lastPressed){
    //     case 1: //left
    //         splash.x = niko.x + 50;
    //         splash.y = niko.y + niko.height / 4;
    //     case 2: //right
    //         splash.x = niko.x - 50;
    //         splash.y = niko.y + niko.height / 4;    
    //     case 3: //up
    //         splash.x = niko.x;
    //         splash.y = niko.y + 100;
    //     case 4,0: //down
    //         splash.x = niko.x;
    //         splash.y = niko.y - 0;
    // }
    splash.x = niko.x;
    splash.y = niko.y + ( splash.height / 2);
    FlxTween.tween(splash, {alpha: 0.01}, 1, {startDelay:0.1});
    new FlxTimer().start(2, function(timr:FlxTimer){
        splash.destroy();
    });
    insert(0, splash);
    // add(splash);

}
function messageSequence(){
                new FlxTimer().start(1,function(ee:FlxTimer){openSubState(new ModSubState("TalkingSubState", {dianumber: 2})); niko.moves = true; canWalk = false; initializedthis = true;});

}
function walkShit(){
    if(goingtoSleep == false && !FlxG.keys.pressed.S && !FlxG.keys.pressed.W && !FlxG.keys.pressed.A && !FlxG.keys.pressed.D){
        switch(lastPressed){
            case 0: niko.playAnim("idle0", true);
            case 1: niko.playAnim("idleleft", true);
            case 2: niko.playAnim("idleright", true);
            case 3: niko.playAnim("idleup", true);
            case 4: niko.playAnim("idle0", true);
        }
    }
    if(FlxG.keys.pressed.S || FlxG.keys.pressed.W || FlxG.keys.pressed.A || FlxG.keys.pressed.D){
        if (FlxG.keys.pressed.A) {
            niko.playAnim(running ? "runleft" : "left");
            lastPressed = 1;
        }
        else if (FlxG.keys.pressed.D) {
            niko.playAnim(running ? "runright" : "right");
            lastPressed = 2;
        }
        else if (FlxG.keys.pressed.W) {
            niko.playAnim(running ? "runup" : "up");
            lastPressed = 3;
        }
        else if (FlxG.keys.pressed.S) {
            niko.playAnim(running ? "rundown" : "down");
            lastPressed = 4;
        }
    }
        if(FlxG.keys.pressed.A || FlxG.keys.pressed.D || FlxG.keys.pressed.S || FlxG.keys.pressed.W){
            playingStep = true;
        } else {
            playingStep = false;
        }    

    if(FlxG.keys.pressed.SHIFT){ running = true; } else { running = false; }
    
    
    niko.velocity.x = 0;
    if(FlxG.keys.pressed.A){
        niko.velocity.x = FlxG.keys.pressed.SHIFT ? -speeds[1] : -speeds[0];
    }
    if(FlxG.keys.pressed.D){
        niko.velocity.x = FlxG.keys.pressed.SHIFT ? speeds[1] : speeds[0];
    }
    if(FlxG.keys.pressed.W){
        niko.velocity.y = FlxG.keys.pressed.SHIFT ? -speeds[1] : -speeds[0];
    }
    if(FlxG.keys.pressed.S){
        niko.velocity.y = FlxG.keys.pressed.SHIFT ? speeds[1] : speeds[0];
    }

    updateLookShit();
    var overlappingthing:FlxSprite = null;

    if (nikoHB.overlaps(computer)) {
        overlappingthing = computer;
    }
    if (bed.alpha >= 0.1 && nikoHB.overlaps(bedHB)) {
        overlappingthing = bedHB;
    }

    if (overlappingthing != null && nikoHB.overlaps(overlappingthing)) {
        var dx:Float = (niko.x + niko.width/2) - (overlappingthing.x + overlappingthing.width/2);
        var dy:Float = (niko.y + niko.height/2) - (overlappingthing.y + overlappingthing.height/2);

        if (Math.abs(dx) > Math.abs(dy)) {
            
            if (dx > 0) {
                niko.velocity.x = speeds[0];  
            } else {
                niko.velocity.x = -speeds[0]; 
            }
        } else {
            if (dy > 0) {
                niko.velocity.y = speeds[0];  
            } else {
                niko.velocity.y = -speeds[0]; 
            }
        }
    }

    if(running == false && _time >= 0.5){
        _time = 0;
        if(FlxG.keys.pressed.S || FlxG.keys.pressed.W || FlxG.keys.pressed.A || FlxG.keys.pressed.D){
            stepSounds[0].play();
            stepTHing();
        }
    }
    
    if(running == true && _time >= 0.20){
        _time = 0;
        if(FlxG.keys.pressed.S || FlxG.keys.pressed.W || FlxG.keys.pressed.A || FlxG.keys.pressed.D){
            stepSounds[0].play(true);
                    stepTHing();

        }
    }

}
function update(elapsed){
    if(FlxG.keys.justPressed.E && canWalk == true){
        if(nikoLook.overlaps(computerHB)){
            openSubState(new ModSubState("TalkingSubState", {dianumber: 1}));
            canWalk = false;
        }
        if(nikoLook.overlaps(bedHB) && bed.alpha == 1  && goingtoSleep == false){
            if(niko.x >= bed.x){
                niko.playAnim("left");
            }
            if(niko.x <= bed.x){
                niko.playAnim("right", true);
            }
            // niko.playAnim("left");
            canWalk = false;
            niko.moves = false;

            goingtoSleep = true;
            FlxTween.tween(niko, {x: bed.x + (bed.width / 2)}, 1, {onComplete: function(){
                niko.alpha = 0.001;
                bed.playAnim("2");
                new FlxTimer().start(2, function(timer:FlxTimer){
                    bed.playAnim("3");
                    new FlxTimer().start(2, function(AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA:FlxTimer){
                        messageSequence();
                    });
                });
            }});
        }
    }
    if(initializedthis == true ){
        if(FlxG.state.subState != null){
            canWalk = false;
        } else {
            canWalk = true;
        }
    }
    // trace(FlxG.state.subState.scriptName);
    if(FlxG.keys.justPressed.M){
        openSubState(new ModSubState("TalkingSubState", {dianumber: 2}));
        canWalk = false;
    }
    niko.velocity.x = 0;
    niko.velocity.y = 0;
    _time += elapsed;
    if(FlxG.keys.justPressed.P){
        FlxG.switchState(new ModState("Limbo"));
    }
    if(FlxG.keys.justPressed.F4){
        openSubState(new ModSwitchMenu());
    }

    if(goingtoSleep == false) {if(canWalk == true ){ walkShit(); } else {
        switch(lastPressed){
            case 0: niko.playAnim("idle0", true);
            case 1: niko.playAnim("idleleft", true);
            case 2: niko.playAnim("idleright", true);
            case 3: niko.playAnim("idleup", true);
            case 4: niko.playAnim("idle0", true);
        }
    }}
}   