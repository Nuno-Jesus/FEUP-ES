Feature: Synchronize the Calendar
  The user syncs its calendar with Sigarra's and fetches its classes for the day

  Scenario: Users can Synchronize Events and Timetable from their personal calendar with Sigarra
    Given I am logged in
    And I open the drawer
    And I tap the "key_Calendário" button
    And I tap the "Sync Button" button
    And I tap the "Confirm Button" button
    And I tap the "Daily" button
    Then I expect the text "IA" to be present