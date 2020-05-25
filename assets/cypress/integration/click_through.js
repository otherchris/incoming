/* eslint-disable no-undef */
context('Click through tour', () => {
    it('register a new user', () => {
        cy.visit('localhost:4000/register');
        cy.get('#user_email')
            .type("a_user");
        cy.get('#user_display_name')
            .type("Howdy Doody");
        cy.get('#user_password')
            .type("a_password");
        cy.get('#user_password_confirmation')
            .type("a_password");
        cy.get('button')
            .click();
    });
    it('log in', () => {
        cy.visit('localhost:4000/login');
        cy.get('#user_username')
            .type("a_user");
        cy.get('#user_password')
            .type("a_password");
        cy.get('button')
            .click();
    });
    it('shifts page basically works', () => {
        cy.visit('localhost:4000/shifts');
        cy.get('input[type="checkbox"').first().click();
        cy.get('button').click();
    });
});
