/* eslint-disable no-undef */
context('Shift Page', () => {
    beforeEach(() => {
        cy.visit('localhost:4000/shifts');
    });
    it('has three days', () => {
        cy.get('ul.day-list')
            .should('have.length', 3);
    });
    it('has all the checkboxes', () => {
        cy.get('input[type="checkbox"]')
            .should('have.length', 144);
    });
});
