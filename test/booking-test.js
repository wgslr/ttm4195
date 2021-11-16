const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TicketBookingSystem", function () {
  const seats = [
    {
      rowNumber: 3,
      seatNumber: 4,
      timestamp: new Date("2100-01-01").getTime(),
      seatViewURL: "wikipedia.org",
      price: 30,
    },
  ];

  it("Constructor should accept title and seats", async function () {
    const TicketBookingSystemFactory = await ethers.getContractFactory(
      "TicketBookingSystem"
    );
    const ticketBookingSystem = await TicketBookingSystemFactory.deploy(
      "Lion King",
      seats
    );
    await ticketBookingSystem.deployed();
    expect(await ticketBookingSystem.show_title()).to.equal("Lion King");
  });

  it("Prevents sales with insufficient payment", async function () {
    const TicketBookingSystemFactory = await ethers.getContractFactory(
      "TicketBookingSystem"
    );
    const ticketBookingSystem = await TicketBookingSystemFactory.deploy(
      "Lion King",
      seats
    );
    await ticketBookingSystem.deployed();
    await expect(
      ticketBookingSystem.buy(0, { value: seats[0].price - 1 })
    ).to.be.revertedWith("The price of the ticket is not correct.");
  });
});
