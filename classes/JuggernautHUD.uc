class JuggernautHUD extends AOCFFAHUD;

function ShowOverlay()
{
	if (Overlay == none)
	{
		super.ShowOverlay();

		Overlay.AddCTFMarkers();
	}
}


function UpdateDynamicHUDMarkers()
{
	local DynHUDMarkerInfo Inf;
	local JuggernautPawn SP;
	local AOCPawn Pawn;
	super.UpdateDynamicHUDMarkers();
	foreach WorldInfo.AllActors(class'AOCPawn' , Pawn)
	{
		SP = JuggernautPawn(Pawn);
		if (SP.IsJuggernaut())
		{
			Inf.RelAct = Pawn;
			Overlay.UpdateCTFEnemyFlag(Canvas.Project(Inf.RelAct.Location + Vect(0.f , 0.f, 60.f)), true);
		}
	}        
}

DefaultProperties
{
}
