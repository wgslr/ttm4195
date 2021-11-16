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
    {
      rowNumber: 4,
      seatNumber: 1,
      timestamp: new Date("2100-01-01").getTime(),
      seatViewURL: "wikipedia.org",
      price: 20,
    },
    {
      rowNumber: 4,
      seatNumber: 2,
      timestamp: new Date("2100-01-01").getTime(),
      seatViewURL: "wikipedia.org",
      price: 20,
    },
  ];

  let TicketBookingSystemFactory;
  let TicketFactory;
  let seller, buyer1, buyer2, buyer3, buyer4;
  let ticketBookingSystem;

  before(async function () {
    [seller, buyer1, buyer2, buyer3, buyer4] = await ethers.getSigners();
    TicketBookingSystemFactory = await ethers.getContractFactory(
      "TicketBookingSystem",
      seller
    );
    TicketFactory = await ethers.getContractFactory("Ticket");
  });

  beforeEach(async function () {
    ticketBookingSystem = await TicketBookingSystemFactory.deploy(
      "Lion King",
      2 * 3600 * 1000,
      seats
    );
    await ticketBookingSystem.deployed();
  });

  it("Constructor should register show title", async function () {
    const ticketBookingSystem = await TicketBookingSystemFactory.deploy(
      "Lion King",
      2 * 3600 * 1000,
      seats
    );
    await ticketBookingSystem.deployed();
    expect(await ticketBookingSystem.show_title()).to.equal("Lion King");
  });

  it("Prevents sales with insufficient payment", async function () {
    await expect(
      ticketBookingSystem.buy(0, { value: seats[0].price - 1 })
    ).to.be.revertedWith("The price of the ticket is not correct.");
  });

  it("Prevents double booking", async function () {
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
    const price = seats[0].price;
    await expect(
      await ticketBookingSystem.connect(buyer1).buy(0, { value: price })
    ).to.changeEtherBalances([ticketBookingSystem, buyer1], [price, -price]);

    const ticketsContractAddr = await ticketBookingSystem
      .connect(buyer1)
      .tickets();

    const tickets = TicketFactory.attach(ticketsContractAddr);
    expect(await tickets.ownerOf(0)).to.be.equal(buyer1.address);
  });

  it("People cannot buy mint tickets without using BookingSystem", async function () {
    const ticketsContractAddr = await ticketBookingSystem.tickets();
    const tickets = TicketFactory.attach(ticketsContractAddr).connect(buyer1);

    await expect(tickets.mintTKT(buyer1.address, 0)).to.be.revertedWith(
      "The calling address is not authorized."
    );
  });

  describe("Revert", function () {
    it("refunds buyers", async function () {
      ticketBookingSystem.connect(buyer1).buy(0, { value: seats[0].price });
      ticketBookingSystem.connect(buyer1).buy(1, { value: seats[1].price });
      ticketBookingSystem.connect(buyer2).buy(2, { value: seats[2].price });

      const totalSpent = seats[0].price + seats[1].price + seats[2].price;

      // TODO: refund() fails, because BookingSystem is not Ticket owner and cannot invoke burn()
      await expect(
        await ticketBookingSystem.connect(seller).refund()
      ).to.changeEtherBalances(
        [ticketBookingSystem, buyer1, buyer2],
        [-totalSpent, seats[0].price + seats[1].price, seats[2].price]
      );
    });
  });

  describe("Trading", function () {
    it("owner can set sale price", async function () {
      ticketBookingSystem.connect(buyer1).buy(0, { value: seats[0].price });
      ticketBookingSystem.connect(buyer1).buy(1, { value: seats[1].price });

      const ticketsContractAddr = await ticketBookingSystem.tickets();
      const ticketsBuyer1 =
        TicketFactory.attach(ticketsContractAddr).connect(buyer1);

      await ticketsBuyer1.setSellable(1, true, 1000);

      const resalePrice = await ticketsBuyer1.getResalePrice(1);
      // each array element asserted separaetly to trigger correct BigNumber handling
      expect(resalePrice[0]).to.equal(true);
      expect(resalePrice[1]).to.equal(1000);

      expect((await ticketsBuyer1.getResalePrice(0))[0]).to.equal(false);
    });

    it("non-owner can not set sellability", async function () {
      ticketBookingSystem.connect(buyer1).buy(0, { value: seats[0].price });

      const ticketsContractAddr = await ticketBookingSystem.tickets();
      const ticketsBuyer2 =
        TicketFactory.attach(ticketsContractAddr).connect(buyer2);

      await expect(ticketsBuyer2.setSellable(0, true, 1000)).to.be.revertedWith(
        "The calling address is not the owner."
      );
      await expect(ticketsBuyer2.setSellable(0, false, 0)).to.be.revertedWith(
        "The calling address is not the owner."
      );
    });

    it("owner can cancel sale offer", async function () {
      ticketBookingSystem.connect(buyer1).buy(0, { value: seats[0].price });
      ticketBookingSystem.connect(buyer1).buy(1, { value: seats[1].price });

      const ticketsContractAddr = await ticketBookingSystem.tickets();
      const ticketsBuyer1 =
        TicketFactory.attach(ticketsContractAddr).connect(buyer1);

      await ticketsBuyer1.setSellable(1, true, 1000);
      await ticketsBuyer1.setSellable(1, false, 1000);

      const resalePrice = await ticketsBuyer1.getResalePrice(1);
      expect(resalePrice[0]).to.equal(false);
      expect(resalePrice[1]).to.equal(0);
    });
  });
});
