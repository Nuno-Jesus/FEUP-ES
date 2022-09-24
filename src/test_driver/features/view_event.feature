Feature: View an event
  A new Scaffold with details about the event, including a map featuring the event's location should appear

  Scenario: Users can tap events to access a detailed view of it
    Given I am logged in
    And I open the drawer
    And I tap the "key_Calendário" button
    And I tap the "Add Event" button
    And I tap the "Save Button" button
    And I tap the "Daily" button
    And I tap the "Event Body" button
    Then I expect the text "No location provided" to be present