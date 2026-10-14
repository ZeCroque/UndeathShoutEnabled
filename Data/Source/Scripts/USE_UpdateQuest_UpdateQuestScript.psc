Scriptname USE_UpdateQuest_UpdateQuestScript extends Quest

GlobalVariable Property USE_ModVersion  Auto

Event OnInit()
    Update()
EndEvent

Function Update()
    USE_ModVersion.SetValue(USE_Utility_ModInfo.GetModVersion())
EndFunction
