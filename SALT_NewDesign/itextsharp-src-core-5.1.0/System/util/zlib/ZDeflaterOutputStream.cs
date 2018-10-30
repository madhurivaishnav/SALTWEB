using System;
using System.IO;
/*
 * $Id: ZDeflaterOutputStream.cs 106 2009-12-07 12:23:50Z psoares33 $
 *
 * This file is part of the iText project.
 * Copyright (c) 1998-2009 1T3XT BVBA
 * Authors: Bruno Lowagie, Paulo Soares, et al.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License version 3
 * as published by the Free Software Foundation with the addition of the
 * following permission added to Section 15 as permitted in Section 7(a):
 * FOR ANY PART OF THE COVERED WORK IN WHICH THE COPYRIGHT IS OWNED BY 1T3XT,
 * 1T3XT DISCLAIMS THE WARRANTY OF NON INFRINGEMENT OF THIRD PARTY RIGHTS.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU Affero General Public License for more details.
 * You should have received a copy of the GNU Affero General Public License
 * along with this program; if not, see http://www.gnu.org/licenses or write to
 * the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA, 02110-1301 USA, or download the license from the following URL:
 * http://itextpdf.com/terms-of-use/
 *
 * The interactive user interfaces in modified source and object code versions
 * of this program must display Appropriate Legal Notices, as required under
 * Section 5 of the GNU Affero General Public License.
 *
 * In accordance with Section 7(b) of the GNU Affero General Public License,
 * you must retain the producer line in every PDF that is created or manipulated
 * using iText.
 *
 * You can be released from the requirements of the license by purchasing
 * a commercial license. Buying such a license is mandatory as soon as you
 * develop commercial activities involving the iText software without
 * disclosing the source code of your own applications.
 * These activities include: offering paid services to customers as an ASP,
 * serving PDFs on the fly in a web application, shipping iText with a closed
 * source product.
 *
 * For more information, please contact iText Software Corp. at this
 * address: sales@itextpdf.com
 */

namespace System.util.zlib {
    /// <summary>
    /// Summary description for DeflaterOutputStream.
    /// </summary>
    public class ZDeflaterOutputStream : Stream {
        protected ZStream z=new ZStream();
        protected int flushLevel=JZlib.Z_NO_FLUSH;
        private const int BUFSIZE = 4192;
        protected byte[] buf=new byte[BUFSIZE];
        private byte[] buf1=new byte[1];

        protected Stream outp;

        public ZDeflaterOutputStream(Stream outp) : this(outp, 6, false) {
        }
    
        public ZDeflaterOutputStream(Stream outp, int level) : this(outp, level, false) {
        }
    
        public ZDeflaterOutputStream(Stream outp, int level, bool nowrap) {
            this.outp=outp;
            z.deflateInit(level, nowrap);
        }
    
    
        public override bool CanRead {
            get {
                // TODO:  Add DeflaterOutputStream.CanRead getter implementation
                return false;
            }
        }
    
        public override bool CanSeek {
            get {
                // TODO:  Add DeflaterOutputStream.CanSeek getter implementation
                return false;
            }
        }
    
        public override bool CanWrite {
            get {
                // TODO:  Add DeflaterOutputStream.CanWrite getter implementation
                return true;
            }
        }
    
        public override long Length {
            get {
                // TODO:  Add DeflaterOutputStream.Length getter implementation
                return 0;
            }
        }
    
        public override long Position {
            get {
                // TODO:  Add DeflaterOutputStream.Position getter implementation
                return 0;
            }
            set {
                // TODO:  Add DeflaterOutputStream.Position setter implementation
            }
        }
    
        public override void Write(byte[] b, int off, int len) {
            if(len==0)
                return;
            int err;
            z.next_in=b;
            z.next_in_index=off;
            z.avail_in=len;
            do{
                z.next_out=buf;
                z.next_out_index=0;
                z.avail_out=BUFSIZE;
                err=z.deflate(flushLevel);
                if(err!=JZlib.Z_OK)
                    throw new IOException("deflating: "+z.msg);
                if (z.avail_out < BUFSIZE)
                    outp.Write(buf, 0, BUFSIZE-z.avail_out);
            } 
            while(z.avail_in>0 || z.avail_out==0);
        }
    
        public override long Seek(long offset, SeekOrigin origin) {
            // TODO:  Add DeflaterOutputStream.Seek implementation
            return 0;
        }
    
        public override void SetLength(long value) {
            // TODO:  Add DeflaterOutputStream.SetLength implementation

        }
    
        public override int Read(byte[] buffer, int offset, int count) {
            // TODO:  Add DeflaterOutputStream.Read implementation
            return 0;
        }
    
        public override void Flush() {
            outp.Flush();
        }
    
        public override void WriteByte(byte b) {
            buf1[0]=(byte)b;
            Write(buf1, 0, 1);
        }

        public void Finish() {
            int err;
            do{
                z.next_out=buf;
                z.next_out_index=0;
                z.avail_out=BUFSIZE;
                err=z.deflate(JZlib.Z_FINISH);
                if(err!=JZlib.Z_STREAM_END && err != JZlib.Z_OK)
                    throw new IOException("deflating: "+z.msg);
                if(BUFSIZE-z.avail_out>0){
                    outp.Write(buf, 0, BUFSIZE-z.avail_out);
                }
            }
            while(z.avail_in>0 || z.avail_out==0);
            Flush();
        }

        public void End() {
            if(z==null)
                return;
            z.deflateEnd();
            z.free();
            z=null;
        }
        
        public override void Close() {
            try{
                try{Finish();}
                catch (IOException) {}
            }
            finally{
                End();
                outp.Close();
                outp=null;
            }
        }
    }
}
