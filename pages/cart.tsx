import { NextPage } from 'next';
import Head from 'next/head';

const Cart: NextPage = () => {
  return (
    <>
      <Head>
        <title>Nossos Produtos!</title>
        <meta name='description' content='Conheça os nossos produtos!' />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <h1>
        Nosso Carrinho!
      </h1>
    </>
  );
}

export default Cart;