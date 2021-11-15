const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TicketBookingSystem", function () {
  it("Constructor should accept title and seats", async function () {
    const TicketBookingSystem = await ethers.getContractFactory(
      "TicketBookingSystem"
    );
    const seats = [
      {
        rowNumber: 3,
        seatNumber: 4,
        timestamp: 500,
        seatViewURL: "wikipedia.org",
        price: 30,
      },
    ];
    const ticketBookingSystem = await TicketBookingSystem.deploy(
      "Lion King",
      seats
    );
    await ticketBookingSystem.deployed();
    expect(await ticketBookingSystem.show_title()).to.equal("Lion King");
    // expect(await ticketBookingSystem.seats()).to.equal(seats);
  });
});
