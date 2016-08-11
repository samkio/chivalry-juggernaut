class JuggernautPlayerController extends AOCFFAPlayerController
    dependson(JuggernautGame);

reliable client function ShowDefaultGameHeader()
{
	if (AOCGRI(Worldinfo.GRI) == none)
	{
		SetTimer(0.1f, false, 'ShowDefaultGameHeader');
		return;
	}

	ClientShowLocalizedHeaderText("Juggernaut",,"Kill the Juggernaut!",true,false);
}

