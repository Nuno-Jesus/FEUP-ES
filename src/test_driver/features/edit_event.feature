Feature: Edit event
  The edited event has its details updated

  Scenario: Users can change the details about a given event
    Given I am logged in
    And I open the drawer
    And I tap the "key_Calendário" button
    And I tap the "Add Event" button
    And I tap the "Save Button" button
    And I tap the "Daily" button
    And I tap the "PopUp Menu" button
    And I tap the "Edit Button" button
    And I tap the "Save Button" button
    Then I expect the text "Unnamed Event" to be present