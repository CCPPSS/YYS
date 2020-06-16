import layout from 'layout';
import content from './home.ejs';
import d from '../data.js';

console.log(d)

export default layout.pushData(d).render(content);
