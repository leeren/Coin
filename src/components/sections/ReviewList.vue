<template>
  <div>
    <p class="tasks">Circulating Supply: {{ circulating }}</p>
    <review  v-for="review in reviews" :review.sync="review"></review>
  </div>
</template>

<script type = "text/javascript" >
import review from './Review'
import Web3 from 'web3'
var web3 = window.web3
export default {
  props: ['reviews'],
  components: {
    review
  },
  data () {
    return {
      toAddress: null,
      toAmount: 0,
      web3: null,
      web3Provider: null,
      balance: 0,
      circulating: 0,
      contracts: {},
      account: null,
      isEditing: false
    }
  },
  mounted () {
    this.getProvider()
    this.circulating = this.getTotalSupply()
  },
  methods: {
    showForm () {
      console.log('FUCK')
      this.isEditing = true
    },
    hideForm () {
      this.isEditing = false
    },
    getProvider () {
      if (typeof web3 !== 'undefined') {
        this.web3Provider = web3.currentProvider
        web3 = new Web3(this.web3Provider)
      } else {
        this.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545')
        web3 = new Web3(this.web3Provider)
      }
      console.log('shit')
    },
    getTotalSupply () {
      var self = this
      const artifacts = require('../../../build/contracts/YelpCoin.json')
      const contract = require('truffle-contract')
      var YelpCoinContract = contract(artifacts)
      YelpCoinContract.setProvider(this.web3Provider)
      var supply = YelpCoinContract.deployed().then(function (instance) {
        var totalSupply = instance.totalSupply().then(function (stuff) {
          self.circulating = stuff.c[0]
        })
        return totalSupply
      })
      console.log('e')
      console.log(supply)
    },
    setSupply (supply) {
      this.circulating = supply
    },
    networkCheck () {
      web3.version.getNetwork((err, netId) => {
        if (err) {
          console.log(err)
          return
        }
        switch (netId) {
          case '8777679':
            console.log('THIS IS YELPCOIN')
            break
          default:
            console.log('THIS IS NOT YELPCOIN')
        }
      })
    },
    getBalances (adopters, account) {
      console.log('getting balances...')
      web3.eth.getAccounts((error, accounts) => {
        if (error) {
          console.log(error)
          return
        }
        this.account = accounts[0]
        console.log(this.account)
        this.contracts.YelpCoin.deployed().then((instance) => {
          var yelpCoinInstance = instance
          return yelpCoinInstance.balanceOf(this.account)
        }).then((result) => {
          console.log(result)
          this.balance = result.c[0]
          console.log('wrfadsadasdadsdas')
          console.log(this.balance)
        }).catch((err) => {
          console.log(err.message)
        })
      })
    },
    makeTransfer () {
      console.log('Transfer ' + this.toAmount + ' TT to ' + this.toAddress)
      var yelpCoinInstance
      web3.eth.getAccounts((error, accounts) => {
        if (error) {
          console.log(error)
          return
        }
        this.account = accounts[0]

        this.contracts.YelpCoin.deployed().then((instance) => {
          yelpCoinInstance = instance
          return yelpCoinInstance.transfer(this.toAddress, this.toAmount, {from: this.account})
        }).then((result) => {
          alert('Transfer Success!')
          return this.getBalances()
        }).catch((err) => {
          console.log(err.message)
        })
      })
    }
  }
}
</script>

<style scoped>
p.tasks {
  text-align: center;
}
</style>

