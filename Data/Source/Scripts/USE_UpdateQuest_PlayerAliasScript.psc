Scriptname USE_UpdateQuest_PlayerAliasScript extends ReferenceAlias

Race Property NecroLichRace Auto

Spell Property LichTransform Auto
Keyword Property WeapTypeStaff Auto
Int[] Property HotkeyCode Auto
Form[] Property HotkeyedObjects Auto

Int Property CustomAttackKeyboardShortcut Auto
Int Property ShoutKeyCode Auto
Int Property ShoutControllerCode Auto
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
    playerRef.RemoveSpell(USE_LichFormTriggerShoutSpell)
    
    IsShouting = False
EndFunction

Event OnAnimationEvent(ObjectReference akSource, string asEventName)  
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
    ElseIf(LichTransform)
        Int i = 0
        While(i < HotkeyedObjects.Length)
            HotkeyedObjects[i] = Game.GetHotkeyBoundObject(i)
            HotkeyCode[i] = Input.GetMappedKey("Hotkey" + (i + 1))
            RegisterForKey(HotkeyCode[i])
            i += 1
        EndWhile
    EndIf
EndEvent

Event OnUpdate()
    ShoutingTime += 0.5
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
    If(Game.GetPlayer().GetRace() == NecroLichRace)
        If(akBaseObject == Game.GetPlayer().GetEquippedObject(2))
            Shout tmp = akBaseObject as Shout
            If(tmp)
                equippedShout = tmp
                ShoutKeyCode = Input.GetMappedKey("Shout", 0x0)
                RegisterForKey(ShoutKeyCode)
                ShoutControllerCode = Input.GetMappedKey("Shout", 0x2)
                RegisterForKey(ShoutControllerCode)
                Game.GetPlayer().UnequipShout(equippedShout)
            Else
                UnregisterForKey(ShoutKeyCode)
                UnregisterForKey(ShoutControllerCode)
            EndIf
        EndIf
    Else
        UnregisterForKey(ShoutKeyCode)
        UnregisterForKey(ShoutControllerCode)
    EndIf
EndEvent

Event OnKeyDown(int keyCode)          
    Actor playerRef = Game.GetPlayer()
    If(playerRef.GetRace() == NecroLichRace)
        If((keyCode == ShoutKeyCode || keyCode == ShoutControllerCode) && !IsShouting)
            If(!Utility.IsInMenuMode() && !playerRef.GetVoiceRecoveryTime())
                IsShouting = True
                playerRef.InterruptCast()
                LeftHandEquipment = playerRef.GetEquippedObject(0)
                RightHandEquipment = playerRef.GetEquippedObject(1)
                playerRef.AddSpell(USE_LichFormTriggerShoutSpell, False)
                playerRef.EquipSpell(USE_LichFormTriggerShoutSpell , 0)
                Input.HoldKey(CustomAttackKeyboardShortcut)
            Else
                Debug.Notification("Your Thu'um is recovering.")
            EndIf
        Else
            Int i = 0
            While(i < HotkeyedObjects.Length)
                If(keyCode == HotkeyCode[i])
                    If(!Utility.IsInMenuMode())
                        If(HotkeyedObjects[i].HasKeyword(WeapTypeStaff))
                            playerRef.EquipItemEx(HotkeyedObjects[i], 1, False, False)
                        Else
                            Spell spellToEquip = HotkeyedObjects[i] as Spell
                            If(spellToEquip)
                                If(playerRef.GetEquippedObject(0) == spellToEquip)
                                    playerRef.EquipSpell(spellToEquip, 1)
                                Else
                                    playerRef.EquipSpell(spellToEquip, 0)
                                EndIf
                            Else
                                Shout shoutToEquip = HotkeyedObjects[i] as Shout
                                If(shoutToEquip)
                                    playerRef.EquipShout(shoutToEquip)
                                EndIf
                            EndIf
                        EndIf
                    Else
                        HotkeyedObjects[i] = Game.GetHotkeyBoundObject(i)
                    EndIf
                    i = HotkeyedObjects.Length
                EndIf
                i += 1
            EndWhile
        EndIf
    EndIf
EndEvent

Event OnKeyUp(int keyCode, float holdTime)
    Input.ReleaseKey(CustomAttackKeyboardShortcut)
EndEvent
