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
    {
      rowNumber: 3,
      seatNumber: 5,
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

  it("Prevents double booking", async function () {
    const [seller, buyer1, buyer2] = await ethers.getSigners();
    const TicketBookingSystemFactory = await ethers.getContractFactory(
      "TicketBookingSystem",
      seller
    );
    const ticketBookingSystem = await TicketBookingSystemFactory.deploy(
      "Lion King",
      seats
    );

    await ticketBookingSystem.connect(buyer1).buy(0, { value: seats[0].price });
    await expect(
      ticketBookingSystem.connect(buyer1).buy(0, { value: seats[0].price }),
      "A seat cannot be reserved twice by the same buyer"
    ).to.be.revertedWith("ERC721: token already minted");
    await expect(
      ticketBookingSystem.connect(buyer2).buy(0, { value: seats[0].price }),
      "A seat cannot be reserved twice by different buyers"
    ).to.be.revertedWith("ERC721: token already minted");
  });

  it("Transfers Ticket to the buyer", async function () {
    const [seller, buyer1, buyer2] = await ethers.getSigners();
    const TicketBookingSystemFactory = await ethers.getContractFactory(
      "TicketBookingSystem",
      seller
    );
    const TicketFactory = await ethers.getContractFactory("Ticket");
    const ticketBookingSystem = await TicketBookingSystemFactory.deploy(
      "Lion King",
      seats
    );

    await ticketBookingSystem.connect(buyer1).buy(0, { value: seats[0].price });

    console.log(
      "Tickets contract: ",
      await ticketBookingSystem.connect(buyer1).tickets()
    );
    const ticketsContractAddr = await ticketBookingSystem
      .connect(buyer1)
      .tickets();

    const tickets = TicketFactory.attach(ticketsContractAddr);
    expect(await tickets.ownerOf(0)).to.be.equal(buyer1.address);
  });
});
