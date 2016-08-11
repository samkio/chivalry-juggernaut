class JuggernautGame extends AOCFFA;

var float GiantHealthRegenScaleMultiplier;
static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
    //returns this object's own class, so this class is setting itself to be the game type used
    return default.class;
}

//TODO Timer to check thhat there is a Juggernaut

function StartRound()
{
    local AOCPlayerController PC;
    isFirstBlood = false;
    BroadcastToAll("Welcome to the Juggernaut game mode! First to get a kill becomes the Juggernaut! Kill the Juggernaut and as the Juggernaut to score points.");
    TimeLeft = RoundTime * 60;
    GameStartTime = WorldInfo.TimeSeconds;
    bGameStarted = true;
    bBeforeFirstRound = false;
    foreach WorldInfo.AllControllers(class'AOCPlayerController', PC)
    {
        PC.InitializeTimer(TimeLeft, true);
        PC.SetWaitingForPlayers(False);
        PC.WarmupUnfrozen();
    }

    // new spawn wave timer
    ClearTimer('SpawnQueueTimer');
    SpawnQueueTimer();
    SetTimer(SpawnWaveInterval, true, 'SpawnQueueTimer');

    bAOCGameEnded=false;

    gotostate( 'AOCRoundInProgress' );

    //End tournament mode (for LTS' sake, this can't persist (since LTS reenters "preround"))
    bTournamentMode = false;
    AOCGRI(GameReplicationInfo).bTournamentModeWaiting = false;
    
    SetTimer( (TimeLeft - FIRST_WARNING_TIME_LEFT), false, 'PlayFirstWarningSound' );
    SetTimer( (TimeLeft - SECOND_WARNING_TIME_LEFT), false, 'PlaySecondWarningSound' );
    SetTimer( (TimeLeft - THIRD_WARNING_TIME_LEFT), false, 'PlayThirdWarningSound' );
    JuggernautCheck();
}


function ScoreKill(Controller Killer, Controller Other)
{

    local JuggernautPawn KillerPawn;
    local JuggernautPawn OtherPawn;
    local AOCPlayerController KillerController;
    local AOCPlayerController OtherController;

    KillerController = AOCPlayerController(Killer);
    OtherController = AOCPlayerController(Other);
    KillerPawn = JuggernautPawn(Killer.Pawn);
    OtherPawn = JuggernautPawn(Other.Pawn);  

    if(KillerPawn != none && OtherPawn != none)
    {

        if (!isFirstBlood)
        {
            if(KillerController!=none){
                KillerController.ReceiveChatMessage("You are now the Juggernaut!",EFAC_ALL,true,false);
            }
            BroadcastToAll(Killer.PlayerReplicationInfo.PlayerName@"is now the Juggernaut!");
            MakeJuggernaut(KillerPawn);
            super.ScoreKill(Killer,Other);
            }else{
                if(KillerPawn.IsJuggernaut()){
                    super.ScoreKill(Killer, Other);
                    }else if(OtherPawn.IsJuggernaut()){
                        super.ScoreKill(Killer, Other);
                        MakeJuggernaut(KillerPawn);
                        if(KillerController!=none){
                            KillerController.ReceiveChatMessage("You are now the Juggernaut!",EFAC_ALL,true,false);
                        }
                        if(OtherController!=none){
                         OtherController.ReceiveChatMessage("You are no longer the Juggernaut!",EFAC_ALL,true,false);
                     }

                     BroadcastToAll(Killer.PlayerReplicationInfo.PlayerName@"is now the Juggernaut!");
                     }else{

                        if(KillerController!=none){
                         KillerController.ReceiveChatMessage("You only score by killing the Juggernaut!",EFAC_ALL,true,false);
                     }
                 }
             }
         }
     }

     function BroadcastToAll(string message){
        local AOCPlayerController PC;
        foreach AllActors(class'AOCPlayerController', PC)
        {
         PC.ReceiveChatMessage(message,EFAC_ALL,true,false);
     }
 }

 function Logout( Controller Exiting )
 {
    local JuggernautPawn exiter;
    exiter = JuggernautPawn(Exiting.pawn);
    if(exiter.IsJuggernaut()){
       BroadcastToAll(Exiting.PlayerReplicationInfo.PlayerName@"has left so next kill becomes the Juggernaut!");
       isFirstBlood = false;
   }
}

function MakeJuggernaut(JuggernautPawn Killer){
 local float NewScale;

 NewScale = 2;

 Killer.Health *= (NewScale / Killer.GiantScale);
 Killer.HealthMax *= (NewScale / Killer.GiantScale);
 Killer.HealAmount = (1 - GiantHealthRegenScaleMultiplier) * Killer.HealAmount + GiantHealthRegenScaleMultiplier * ((NewScale / Killer.GiantScale) * Killer.HealAmount);


 Killer.SetGiantScale(NewScale);
}

function JuggernautCheck(){
    local JuggernautPawn SP;
    local AOCPawn Pawn;
    SetTimer(5, false, 'JuggernautCheck' );
    foreach WorldInfo.AllActors(class'AOCPawn' , Pawn)
    {
        SP = JuggernautPawn(Pawn);
        if (SP.IsJuggernaut() && SP.Health > 0 && !SP.bPawnIsDead)
        {
            return;
        }
    }        
    BroadcastToAll("There is no Juggernaut so next kill becomes the Juggernaut!");
    isFirstBlood = false;

}



defaultproperties
{
    ModDisplayString="Juggernaut"
    //We won't leave these in here, but for now they'll let us see if the mod is actually loaded...
    SpawnWaveInterval=1
    MinimumRespawnTime=0

    HUDType=class'JuggernautHUD'
    //Use our new, custom pawn class instead of AOCPawn
    DefaultPawnClass=class'JuggernautPawn'
    PlayerControllerClass=class'JuggernautPlayerController'
    //Don't scale health regen up at full speed beacause it could easily get ridiculous...
    GiantHealthRegenScaleMultiplier = 0.5
}
