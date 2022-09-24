Feature: Use google maps
  If the student is on the detailed event view, clicking on the map will open a new scaffold with a bigger map

  Scenario: Students can click on the map on the event fully detailed view
    Given I am logged in
    And I open the drawer
    And I tap the "key_Calendário" button
    And I tap the "Add Event" button
    And I tap the "Save Button" button
    And I tap the "Daily" button
    And I tap the "Event Body" button
    And I pause for 5 seconds
    And I tap the "Map" button
    Then I expect the text "Location" to be absent