async function main() {
  // We get the contract to deploy
  const Greeter = await ethers.getContractFactory("TicketBookingSystem");
  const greeter = await Greeter.deploy("Batman", []);

  console.log("TicketBookingSystem deployed to:", greeter.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
