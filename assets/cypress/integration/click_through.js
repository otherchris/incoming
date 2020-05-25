/* eslint-disable no-undef */
context('Click through tour', () => {
    beforeEach(() => {
        cy.visit('localhost:4000/shifts');
    });
    it('basically works', () => {
        cy.get('input[type="checkbox"').first().click();
        cy.get('button').click();
    });
});
