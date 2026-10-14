Scriptname USE_UpdateQuest_PlayerAliasScript extends ReferenceAlias

Spell Property USE_TriggerShoutSpell Auto
Spell Property DLC1VoiceSoulTear3 Auto 

Event OnInit()
    RegisterAnims()
EndEvent

Event OnPlayerLoadGame()
    (GetOwningQuest() as USE_UpdateQuest_UpdateQuestScript).Update()
    RegisterAnims()
EndEvent

Function RegisterAnims()
    Debug.Trace("USE_RegisterAnims")
    RegisterForAnimationEvent(GetRef(), "SpellStart")
	RegisterForAnimationEvent(GetRef(), "SpellRelease")
    RegisterForAnimationEvent(GetRef(), "IdleRitualSpell_Release")
    RegisterForAnimationEvent(GetRef(), "RitualSpell_ReadyLoop")
    RegisterForAnimationEvent(GetRef(), "MRh_SpellFire_Event")
    RegisterForAnimationEvent(GetRef(), "RitualSpellOut")
    RegisterForAnimationEvent(GetRef(), "MLh_SpellFire_Event") ;That's the one
    RegisterForAnimationEvent(GetRef(), "MLh_PreReady")
    RegisterForAnimationEvent(GetRef(), "MLh_PreAimedOut")
    RegisterForAnimationEvent(GetRef(), "MLh_ReadyLoop")
    RegisterForAnimationEvent(GetRef(), "MLh_PreReady")
    RegisterForAnimationEvent(GetRef(), "Mag_Pre_Out")
    RegisterForAnimationEvent(GetRef(), "RitualSpell_Release")
    RegisterForAnimationEvent(GetRef(), "DualMagic_PreSelfCharge")
    RegisterForAnimationEvent(GetRef(), "DualMagic_SelfReadyLoop")
    RegisterForAnimationEvent(GetRef(), "DualMagic_SelfRelease")
    RegisterForAnimationEvent(GetRef(), "DualMagic_AimChargeLoop")
    RegisterForAnimationEvent(GetRef(), "DualMagic_AimRelease")
    RegisterForAnimationEvent(GetRef(), "DualMagic_AimPreCharge")
    RegisterForAnimationEvent(GetRef(), "DualMagic_ReadyLoop")
    RegisterForAnimationEvent(GetRef(), "Mag_Dual_ff_R_charge_pre")
    RegisterForAnimationEvent(GetRef(), "Mag_Dual_ff_R_release")
    RegisterForAnimationEvent(GetRef(), "Mag_Dual_ff_R_charge")
    RegisterForAnimationEvent(GetRef(), "Mag_Dual_ff_S_charge_pre")
    RegisterForAnimationEvent(GetRef(), "Mag_Dual_ff_S_release")
    RegisterForAnimationEvent(GetRef(), "Mag_Dual_ff_S_charge")
    RegisterForAnimationEvent(GetRef(), "Mag_LH_ff_S_release")
    RegisterForAnimationEvent(GetRef(), "Mag_LH_ff_S_charge")
    RegisterForAnimationEvent(GetRef(), "Mag_LH_ff_S_harge_pre")
    RegisterForAnimationEvent(GetRef(), "Mag_LH_ff_R_release")
    RegisterForAnimationEvent(GetRef(), "Mag_LH_ff_R_charge")
    RegisterForAnimationEvent(GetRef(), "Mag_LH_ff_R_harge_pre")
    RegisterForAnimationEvent(GetRef(), "Mag_RH_ff_S_release")
    RegisterForAnimationEvent(GetRef(), "Mag_RH_ff_S_charge")
    RegisterForAnimationEvent(GetRef(), "Mag_RH_ff_S_harge_pre")
    RegisterForAnimationEvent(GetRef(), "Mag_RH_ff_R_release")
    RegisterForAnimationEvent(GetRef(), "Mag_RH_ff_R_charge")
    RegisterForAnimationEvent(GetRef(), "Mag_RH_ff_R_harge_pre")
    RegisterForAnimationEvent(GetRef(), "MLh_SpellReady_Event")
    RegisterForAnimationEvent(GetRef(), "MLh_SpellRelease_Event")
    RegisterForAnimationEvent(GetRef(), "MLh_BeginCast_Event")
    RegisterForAnimationEvent(GetRef(), "na_MLh_BeginCast_Event")
    RegisterForAnimationEvent(GetRef(), "MLh_BeginCast_Event_end")
    RegisterForAnimationEvent(GetRef(), "BeginCastLeft")
    RegisterForAnimationEvent(GetRef(), "BeginCastRight")
    RegisterForAnimationEvent(GetRef(), "na_DualMagic_BeginCast_Event")    
    RegisterForAnimationEvent(GetRef(), "MLh_SpellFireForgetS_Start")
    RegisterForAnimationEvent(GetRef(), "InterruptCast")
EndFunction
bool Property iscastinghelper Auto
float Property accutime Auto
Event OnAnimationEvent(ObjectReference akSource, string asEventName)  
    Debug.Trace(asEventName)
    iscastinghelper = false
  	if (asEventName == "BeginCastLeft")
        If(!Game.GetPlayer().GetVoiceRecoveryTime())
            If(Game.GetPlayer().GetEquippedObject(0) == USE_TriggerShoutSpell)
                iscastinghelper = true
                accutime = 0
                RegisterForUpdate(0.5)
            EndIf
        Else
            Game.GetPlayer().InterruptCast()
            Debug.Notification("Your Thu'um is recovering.")
        EndIf
  	endIf
endEvent

Event OnSpellCast(Form akSpell)
    If(iscastinghelper)
        ;DLC1VoiceSoulTear3.Cast(Game.GetPlayer())
        Shout equippedShout = Game.GetPlayer().GetEquippedObject(2) as Shout
        If(equippedShout)
            Int shoutIndex = 0
            If(accutime <= 0.5)
                Debug.Notification("word1")
            ElseIf(accutime <= 1.5)
                Debug.Notification("word2")
                If(Game.IsWordUnlocked(equippedShout.GetNthWordOfPower(1)))
                    shoutIndex = 1
                EndIf
            Else
                Debug.Notification("word3")
                If(Game.IsWordUnlocked(equippedShout.GetNthWordOfPower(2)))
                    shoutIndex = 2
                Else
                    shoutIndex = 1
                EndIf
            EndIf

            equippedShout.GetNthSpell(shoutIndex).Cast(Game.GetPlayer())
            Game.GetPlayer().SetVoiceRecoveryTime(equippedShout.GetNthRecoveryTime(shoutIndex))
        EndIf
        UnregisterForUpdate()
    EndIf
    Debug.Trace("USE_OnSpellStart")
EndEvent

Event OnUpdate()
    accutime += 0.5
EndEvent
