/* eslint-disable no-undef */
context('Shift Page', () => {
    beforeEach(() => {
        cy.visit('localhost:4000/shifts');
    });
    it('has three days', () => {
        cy.get('ul.day-list')
            .should('have.length', 3);
    });
});
