Scriptname USE_UpdateQuest_PlayerAliasScript extends ReferenceAlias

Int Property CustomAttackKeyboardShortcut Auto
Spell Property USE_LichFormTriggerShoutSpell Auto
Form Property LeftHandEquipment Auto
Form Property RightHandEquipment Auto
Shout Property equippedShout Auto
Bool Property IsShouting Auto
Float Property ShoutingTime Auto

Event OnInit()
    RegisterAnims()
EndEvent

Event OnPlayerLoadGame()
    (GetOwningQuest() as USE_UpdateQuest_UpdateQuestScript).Update()
    RegisterAnims()
EndEvent

Function RegisterAnims()
    CustomAttackKeyboardShortcut = Input.GetMappedKey("Left Attack/Block", 0)
    If(CustomAttackKeyboardShortcut == -1)
        Debug.MessageBox("You need to delete the ControlMap_Custom.txt file from Skyrim's folder. You can then set again your keybinds, without changing the left attack control that is set to '???'. Shouting feature is currently disabled.")
    Else
        RegisterForAnimationEvent(GetRef(), "BeginCastLeft")
        RegisterForAnimationEvent(GetRef(), "InterruptCast")
    EndIf
EndFunction

Function StopShouting()
    Actor playerRef = Game.GetPlayer()

    Spell leftSpell = LeftHandEquipment as Spell
    If(leftSpell)     
        playerRef.EquipSpell(leftSpell, 0)
    Else
        playerRef.EquipItemEx(LeftHandEquipment, 0, False, False)
    EndIf

    Spell rightSpell = RightHandEquipment as Spell
    If(rightSpell)     
        playerRef.EquipSpell(RightHandEquipment as Spell, 1)
    Else
        playerRef.EquipItemEx(RightHandEquipment, 1, False, False)
    EndIf

    IsShouting = False
EndFunction

Event OnAnimationEvent(ObjectReference akSource, string asEventName)  
    Debug.Trace(asEventName)
    If(Game.GetPlayer().GetEquippedObject(0) == USE_LichFormTriggerShoutSpell)  
        If(asEventName == "BeginCastLeft")      
            ShoutingTime = 0.0
            RegisterForUpdate(0.5)
        ElseIf("InterruptCast")
            UnregisterForUpdate()
            StopShouting()
        EndIf       
    EndIf
endEvent

Event OnSpellCast(Form akSpell)
    If(akSpell == USE_LichFormTriggerShoutSpell)
        If(equippedShout)        
            Actor playerRef = Game.GetPlayer()

            Int shoutIndex = 0
            If(ShoutingTime <= 0.5)
                Debug.Notification("word1")
            ElseIf(ShoutingTime <= 1.5)
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
            equippedShout.GetNthSpell(shoutIndex).Cast(playerRef)
            playerRef.SetVoiceRecoveryTime(equippedShout.GetNthRecoveryTime(shoutIndex)) 

            StopShouting()
        EndIf
        UnregisterForUpdate()
    EndIf
    Debug.Trace("USE_OnSpellStart")
EndEvent

Event OnUpdate()
    ShoutingTime += 0.5
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
    Debug.Trace("USE_Equipped" + akBaseObject)
    Shout tmp = akBaseObject as Shout
    If(tmp)
        equippedShout = tmp
        RegisterForKey(Input.GetMappedKey("Shout", 0x0))
        RegisterForKey(Input.GetMappedKey("Shout", 0x2))
        Game.GetPlayer().UnequipShout(equippedShout)
    EndIf
EndEvent

Event OnKeyDown(int keyCode)
    If(!IsShouting)
        Actor playerRef = Game.GetPlayer()

        If(!playerRef.GetVoiceRecoveryTime())
            IsShouting = True
            LeftHandEquipment = playerRef.GetEquippedObject(0)
            RightHandEquipment = playerRef.GetEquippedObject(1)
            playerRef.EquipSpell(USE_LichFormTriggerShoutSpell , 0)
            Input.HoldKey(CustomAttackKeyboardShortcut)
        Else
            Debug.Notification("Your Thu'um is recovering.")
        EndIf
    EndIf
EndEvent

Event OnKeyUp(int keyCode, float holdTime)
    Input.ReleaseKey(CustomAttackKeyboardShortcut)
EndEvent
