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
Bool Property FirstShoutWordPlayed Auto
Float Property ShoutingTime Auto
Float Property SecondWordThreshold Auto
Float Property ThirdWordThreshold Auto
FormList Property USE_ShoutMiscList Auto
USE_Shout_MiscObjectScript Property EquippedShoutMisc Auto 
Race Property ArgonianRace Auto
Race Property DarkElfRace Auto
Race Property HighElfRace Auto
Race Property WoodElfRace Auto
Race Property ImperialRace Auto
Race Property NordRace Auto
Race Property RedguardRace Auto
Race Property BretonRace Auto
Race Property KhajiitRace Auto
Race Property OrcRace Auto
Quest Property NecroLichRitualQuest Auto
Int Property PlayerVoiceIndex Auto
Message Property USE_VoiceCooldownMessage Auto
Shout Property DLC2DragonAspectShout Auto
Bool Property DragonAspectReady Auto
Message Property USE_DragonAspectCooldownMessage Auto

Int Function GetWordVoiceIndex()
    Int voiceIndex = -1
    Race playerRace = (NecroLichRitualQuest as NecroLichTrackingQuest).PlayerOriginalRace
    If(playerRace == ArgonianRace)
        voiceIndex = 0
    ElseIf(playerRace == DarkElfRace || playerRace == HighElfRace || playerRace == WoodElfRace)
        voiceIndex = 2
    ElseIf(playerRace == ImperialRace || playerRace == NordRace || playerRace == RedguardRace || playerRace == BretonRace)
        voiceIndex = 4
    ElseIf(playerRace == KhajiitRace)
        voiceIndex = 6
    ElseIf(playerRace == OrcRace)
        voiceIndex = 8
    EndIf

    If(Game.GetPlayer().GetActorBase().GetSex() == 0)
        voiceIndex += 1
    EndIf
    Return voiceIndex
EndFunction

Event OnInit()
    Init()
EndEvent

Event OnPlayerLoadGame()
    (GetOwningQuest() as USE_UpdateQuest_UpdateQuestScript).Update()
    Init()
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

Function Init()
    RegisterAnims()
    PlayerVoiceIndex = GetWordVoiceIndex()
    HandleShout(Game.GetPlayer().GetEquippedObject(2))
    If(Game.GetPlayer().GetRace() == NecroLichRace)
        InitHotkeys()
    EndIf
EndFunction

Function InitHotkeys()
    Int i = 0
    While(i < HotkeyedObjects.Length)
        HotkeyedObjects[i] = Game.GetHotkeyBoundObject(i)
        HotkeyCode[i] = Input.GetMappedKey("Hotkey" + (i + 1))
        RegisterForKey(HotkeyCode[i])
        i += 1
    EndWhile
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
            RegisterForUpdate(0.25)
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

            IsShouting = False
            Int shoutIndex = 0
            If(ShoutingTime < SecondWordThreshold)
                (EquippedShoutMisc.StartShortWordMisc as USE_Word_MiscObjectScript).WordSounds[PlayerVoiceIndex].Play(playerRef)
            ElseIf(ShoutingTime < ThirdWordThreshold)
                If(Game.IsWordUnlocked(equippedShout.GetNthWordOfPower(1)))
                    (EquippedShoutMisc.EndShortWordMisc as USE_Word_MiscObjectScript).WordSounds[PlayerVoiceIndex].Play(playerRef)
                    shoutIndex = 1
                EndIf
            Else
                If(Game.IsWordUnlocked(equippedShout.GetNthWordOfPower(2)))
                    (EquippedShoutMisc.EndLongWordMisc as USE_Word_MiscObjectScript).WordSounds[PlayerVoiceIndex].Play(playerRef)
                    shoutIndex = 2
                ElseIf(Game.IsWordUnlocked(equippedShout.GetNthWordOfPower(1)))
                    (EquippedShoutMisc.EndShortWordMisc as USE_Word_MiscObjectScript).WordSounds[PlayerVoiceIndex].Play(playerRef)
                    shoutIndex = 1
                Else
                    (EquippedShoutMisc.StartShortWordMisc as USE_Word_MiscObjectScript).WordSounds[PlayerVoiceIndex].Play(playerRef)
                EndIf
            EndIf
            equippedShout.GetNthSpell(shoutIndex).Cast(playerRef)
            playerRef.SetVoiceRecoveryTime(equippedShout.GetNthRecoveryTime(shoutIndex)) 

            StopShouting()

            If(equippedShout == DLC2DragonAspectShout)
                DragonAspectReady = False
                RegisterForSingleUpdateGameTime(24)
            EndIf
        EndIf
        UnregisterForUpdate()
    ElseIf(LichTransform)
        InitHotkeys()
        Utility.Wait(2) ;Added a small delay because the anim needs to be registered after the transformation is complete
        RegisterAnims()
    EndIf
EndEvent

Event OnUpdateGameTime()
    DragonAspectReady = True
EndEvent

Event OnUpdate()    
    ShoutingTime += 0.25
    If(Game.IsWordUnlocked(equippedShout.GetNthWordOfPower(1)) && ShoutingTime >= SecondWordThreshold && !FirstShoutWordPlayed && IsShouting)
        (EquippedShoutMisc.StartLongWordMisc as USE_Word_MiscObjectScript).WordSounds[PlayerVoiceIndex].Play(Game.GetPlayer())
        FirstShoutWordPlayed = True
    EndIf
EndEvent

Function HandleShout(Form akBaseObject)
    If(CustomAttackKeyboardShortcut != -1 && Game.GetPlayer().GetRace() == NecroLichRace)
        If(akBaseObject == Game.GetPlayer().GetEquippedObject(2))
            Shout tmp = akBaseObject as Shout
            If(tmp)
                equippedShout = tmp
                ShoutKeyCode = Input.GetMappedKey("Shout", 0x0)
                RegisterForKey(ShoutKeyCode)
                ShoutControllerCode = Input.GetMappedKey("Shout", 0x2)
                RegisterForKey(ShoutControllerCode)
                Game.GetPlayer().UnequipShout(equippedShout)

                Int i = 0
                While(i < USE_ShoutMiscList.GetSize())
                    USE_Shout_MiscObjectScript tmpMisc = USE_ShoutMiscList.GetAt(i) as USE_Shout_MiscObjectScript
                    If(tmpMisc.TargetShout == equippedShout)
                        EquippedShoutMisc = tmpMisc
                        i = USE_ShoutMiscList.GetSize()
                    EndIf
                    i += 1
                EndWhile
            Else
                UnregisterForKey(ShoutKeyCode)
                UnregisterForKey(ShoutControllerCode)
            EndIf
        EndIf
    Else
        UnregisterForKey(ShoutKeyCode)
        UnregisterForKey(ShoutControllerCode)
    EndIf
EndFunction

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
    HandleShout(akBaseObject)
EndEvent

Event OnKeyDown(int keyCode)          
    Actor playerRef = Game.GetPlayer()
    If(playerRef.GetRace() == NecroLichRace)
        If((keyCode == ShoutKeyCode || keyCode == ShoutControllerCode) && !IsShouting)
            If(!Utility.IsInMenuMode() && !playerRef.GetVoiceRecoveryTime() && (equippedShout != DLC2DragonAspectShout || DragonAspectReady))
                IsShouting = True
                FirstShoutWordPlayed = False
                playerRef.InterruptCast()
                LeftHandEquipment = playerRef.GetEquippedObject(0)
                RightHandEquipment = playerRef.GetEquippedObject(1)
                playerRef.AddSpell(USE_LichFormTriggerShoutSpell, False)
                playerRef.EquipSpell(USE_LichFormTriggerShoutSpell , 0)
                Input.HoldKey(CustomAttackKeyboardShortcut)
            ElseIf(equippedShout == DLC2DragonAspectShout && !DragonAspectReady)
                USE_DragonAspectCooldownMessage.Show()
            Else
                USE_VoiceCooldownMessage.Show()     
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
