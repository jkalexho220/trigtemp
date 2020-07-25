//==============================================================================
// rmsuddendeath.xs
//
// A really, really simple victory condition script.
//==============================================================================

include "basicvcnomain.xs";

// this rule checks if a player's Citadel is gone
// run this every ~4 seconds.
rule lostCitadel
   minInterval 4
   maxInterval 5
   active
{
   int prevPlayer = xsGetContextPlayer();

   //Iterate over the players.
   for (i=1; < cNumberPlayers)
   {
      xsSetContextPlayer(i);
      //Don't check players who have already lost
      if (kbHasPlayerLost(i) == false)
      {
         int count = 0;
         count = count + kbUnitCount(i, cUnitTypeCitadelCenter, cUnitStateAlive);

         //If we don't have any, this player is done.
         if (count <= 0)
         {
            //trEcho("You have lost, Player #"+i+".");
            
            trSetPlayerDefeated(i); // note that this func must be called synchronously on all machines
         }
      }
   }

   xsSetContextPlayer(prevPlayer);
}
