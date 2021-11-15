const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TicketBookingSystem", function() {

	it("Constructor should accept title and seats", async function() {
		const TicketBookingSystem = await ethers.getContractFactory("TicketBookingSystem");
		const ticketBookingSystem = await TicketBookingSystem.deploy("Lion King", []);
		await ticketBookingSystem.deployed();

		expect(await ticketBookingSystem.show_title()).to.equal("Lion King");

	})

})

