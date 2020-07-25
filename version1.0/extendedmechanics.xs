//=================================================================================================================================
// extendedmechanics.xs
// Creator: WarriorMario
//
// Some extended functionality for certain units. Is not dependend on the victory conditions and can be run without in for example
// scenarios.
// Created with ADE v0.09
//=================================================================================================================================

// Globals for tuning
float healSpeed  = -50;
float healRange  = 10;

// Global variables
int qilinDeathQuery = -1;
int qilinID   = -1;
int tsunamiQuery	= -1;
int tsunamiID	 = -1;

rule initExtendedMechanics
active
runImmediately
minInterval 0
maxInterval 0
priority 100
{
	xsEnableRule("QilinDeathHack");
	xsEnableRule("TsunamiDamageHack");
	qilinID   = kbGetProtoUnitID("Qilin Heal");
	tsunamiID = kbGetProtoUnitID("Tsunami");
	//kbUnitQuerySetSeeableOnly(tsunamiQuery, false);
	xsDisableSelf();
}

//=================================================================================================================================
// QilinDeathHack
// This rule adds the heal on death functionality for the Qilin
// It's just an instant heal so we do not need to care how often we run as long as we run it once
//=================================================================================================================================
rule QilinDeathHack
inactive
minInterval 1
maxInterval 1
priority 100
{
	int prevPlayer = xsGetContextPlayer();
	for(pid=0;<cNumberPlayers)
	{
		xsSetContextPlayer(pid);
		int Qid = kbUnitQueryCreate("Qilin");
		kbUnitQuerySetPlayerID(Qid, pid);
		kbUnitQuerySetUnitType(Qid,qilinID);
		kbUnitQuerySetState(Qid,2);
		
		int num = kbUnitQueryExecute(Qid);
		for(i=0;<num)
		{
			trUnitSelectClear();
			trUnitSelectByID(kbUnitQueryGetResult(Qid,i));
			trDamageUnitsInArea(pid,"LogicalTypeCanBeHealed",healRange,healSpeed);
			trUnitDelete(false);
		}
	}
	xsSetContextPlayer(prevPlayer);
}

rule TsunamiDamageHack
inactive
minInterval 1
maxInterval 1
priority 100
{
	int prevPlayer = xsGetContextPlayer();
	for(pid=0;<cNumberPlayers)
	{
		xsSetContextPlayer(pid);
		int tsunamiQuery = kbUnitQueryCreate("Tsunami");
		kbUnitQueryResetResults(tsunamiQuery);
		kbUnitQuerySetPlayerID(tsunamiQuery, pid);
		kbUnitQuerySetUnitType(tsunamiQuery,tsunamiID);
		kbUnitQuerySetState(tsunamiQuery,2);
		kbLookAtAllUnitsOnMap();
		int num = kbUnitQueryExecute(tsunamiQuery);
		for(i=0;<num)
		{
			trUnitSelectClear();
			trUnitSelectByID(kbUnitQueryGetResult(tsunamiQuery,i));
			vector test = kbUnitGetPosition(kbUnitQueryGetResult(tsunamiQuery,i));
			trUnitCreate("Big Splash", "Default", xsVectorGetX(test),xsVectorGetY(test),xsVectorGetZ(test) ,0, 1);
		}
	}
	
	//xsSetContextPlayer(prevPlayer);
	//int prevPlayer = xsGetContextPlayer();
	//	xsSetContextPlayer(0);
	//	kbLookAtAllUnitsOnMap();
	//tsunamiQuery = kbUnitQueryCreate("Tsunami query");
	//kbUnitQuerySetUnitType(tsunamiQuery,tsunamiID);
	//kbUnitQuerySetPlayerRelation(tsunamiQuery,-1);
	//	kbUnitQuerySetState(tsunamiQuery ,2);
	//	kbUnitQueryResetResults(tsunamiQuery);
	//int num = kbUnitQueryExecute(tsunamiQuery);
	//trChatSend(1, "t"+num);
	//for(i=0;<num)
	//{
	//	trUnitSelectClear();
	//	trUnitSelectByID(kbUnitQueryGetResult(tsunamiQuery,i));
	//	trDamageUnitsInArea(1,"LogicalTypeCanBeHealed",healRange,healSpeed);
	//	vector test = kbUnitGetPosition(kbUnitQueryGetResult(tsunamiQuery,i));
	//	trUnitCreate("Big Splash", "Default", xsVectorGetX(test),xsVectorGetY(test),xsVectorGetZ(test) ,0, 1);
	//	trUnitCreate("Villager Greek", "Default", xsVectorGetX(test),xsVectorGetY(test),xsVectorGetZ(test) ,0, 1);
	//	trUnitDelete(false);
	//}
	//xsSetContextPlayer(prevPlayer);
}
