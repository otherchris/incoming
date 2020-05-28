/* eslint-disable no-undef */
function makeemail() {
    var result = '';
    var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    var charactersLength = characters.length;
    for (var i = 0; i < 10; i++) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result + "@example.com";
}

Cypress.Commands.add('login', (email, pw) => {
    cy.visit("localhost:4000/login");
    cy.get('#user_email')
        .type(email);
    cy.get('#user_password')
        .type(pw);
    cy.get('button').click();
});

context('Click through tour', () => {
    var email = makeemail();
    var password = "penutbuter"

    it('shows the homepage', () => {
        cy.visit('localhost:4000');
        cy.contains('Incoming');
        cy.contains('Log In');
        cy.contains('Welcome to Incoming');
    });

    it('register a new user', () => {
        cy.visit('localhost:4000/register');
        cy.get('#user_email')
            .type(email);
        cy.get('#user_display_name')
            .type("Howdy Doody");
        cy.get('#user_phone')
            .type("502x555x1234");
        cy.get('#user_password')
            .type(password);
        cy.get('#user_password_confirmation')
            .type(password);
        cy.get('button')
            .click();
        cy.get('#phone_confirm_code')
            .type('999999');
        cy.get('button')
            .click();
    });

    it('log in', () => {
        cy.login(email, password);
        cy.contains('Dashboard');
        cy.url().should('include', 'dashboard');
    });

    it('shifts page basically works', () => {
        cy.login(email, password);
        cy.visit('localhost:4000/shifts');
        cy.get('input[type="checkbox"').last().click();
        cy.get('button').click();
    });

    it('dashboard page', () => {
        cy.login(email, password);
        cy.visit('localhost:4000/dashboard');
        cy.contains('Your Shifts');
        cy.contains('a', 'Get Shifts').click();
        cy.url().should('include', 'shifts');
    });
});
