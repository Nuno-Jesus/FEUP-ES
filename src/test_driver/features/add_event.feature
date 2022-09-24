Feature: Add event
  The new added event should appear below the Calendar

  Scenario: Users can add events to their personal calendar
    Given I am logged in
    And I open the drawer
    And I tap the "key_Calendário" button
    And I tap the "Add Event" button
    And I tap the "Save Button" button
    And I tap the "Daily" button
    Then I expect the text "Unnamed Event" to be present