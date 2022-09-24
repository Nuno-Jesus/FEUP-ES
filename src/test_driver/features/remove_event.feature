Feature: Remove event
  The removed event should not appear below the Calendar

  Scenario: Users remove events from their calendars
    Given I am logged in
    And I open the drawer
    And I tap the "key_Calendário" button
    And I tap the "Add Event" button
    And I tap the "Save Button" button
    And I tap the "Daily" button
    And I tap the "PopUp Menu" button
    And I tap the "Delete Button" button
    And I tap the "Yes Button" button
    Then I expect the text "Unnamed Event" to be absent