import React, {Component} from 'react';
import './App.css';
import Web3 from 'web3';
import Test from '../abis/Test.json';
import Counter from '../abis/Counter.json';

class App extends Component{

  constructor(props) {
    super(props);
    this.state = {count : 0}
    this.increase = this.increase.bind(this)
  }

  componentWillMount(){
    this.loadBlockchainData()
  }

  // componentDidMount(){
  // }

  async loadBlockchainData(){
    const web3 = new Web3(window.ethereum)      
    const networkId = await web3.eth.net.getId()
    // console.log("networkId", networkId)
   
    const accounts = await web3.eth.getAccounts()  
    
    
    const account = accounts[0]
    if(!account) {
      await window.ethereum.enable()
    }
    console.log("account", account)
    this.setState({account: account})
      
    const abi = Counter.abi;
    const address = await Counter.networks[networkId].address;
    const counter = new web3.eth.Contract(abi, address)      
    this.setState({contract:counter})
    counter.events.ValueChanged({}, (error, event) => { 
      console.log("event", event.returnValues)
      //this.setState({e:event})
    })
  }

  increase = async() => {
    var _count = await this.state.contract.methods.getCount().call()
    // console.log("inside increment(), count is ", _count)
      await this.state.contract.methods.increment().send({ from: this.state.account})
      // .on('transactionHash', (hash) => {
      //   console.log(hash)
      // })
      // .on('error',(error) => {
      //   console.error(error)
      //   window.alert('There was an error!')
      // })
      // _count = await this.state.contract.methods.getCount().call()
      this.setState({count : _count})
      console.log("after increment(), count is ", _count)
  }

  render(){
    return (
      <div>
        <header>Social Recovery Wallet</header>
        <p>text goes here...</p>
        <button onClick={this.increase}>Increase</button>
        <p>The count is {this.state.count}</p>
      </div>)
  }
}

export default App;
