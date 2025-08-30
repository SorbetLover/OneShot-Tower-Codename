

static var redirectStates:Map<FlxState, String> = [
    TitleState => "Limbo"
];

function preStateSwitch() {
    for (redirectState in redirectStates.keys())
        if (FlxG.game._requestedState is redirectState)
            FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
}

