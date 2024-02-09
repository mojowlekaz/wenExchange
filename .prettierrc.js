module.exports = {
  semi: false,
  singleQuote: true,
  tabWidth: 4,
  printWidth: 120,
  overrides: [
    {
      files: "*.sol",
      options: {
        parser: "solidity",
        singleQuote: false,
        tabWidth: 4,
        printWidth: 120
      }
    }
  ]
};
