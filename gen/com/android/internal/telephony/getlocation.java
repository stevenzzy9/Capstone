/*
 * This file is auto-generated.  DO NOT MODIFY.
 * Original file: /Users/ZhenyuZhang/Documents/Interview/Capstone/code/StatusManagerService/src/com/android/internal/telephony/getlocation.aidl
 */
package com.android.internal.telephony;
public interface getlocation extends android.os.IInterface
{
/** Local-side IPC implementation stub class. */
public static abstract class Stub extends android.os.Binder implements com.android.internal.telephony.getlocation
{
private static final java.lang.String DESCRIPTOR = "com.android.internal.telephony.getlocation";
/** Construct the stub at attach it to the interface. */
public Stub()
{
this.attachInterface(this, DESCRIPTOR);
}
/**
 * Cast an IBinder object into an com.android.internal.telephony.getlocation interface,
 * generating a proxy if needed.
 */
public static com.android.internal.telephony.getlocation asInterface(android.os.IBinder obj)
{
if ((obj==null)) {
return null;
}
android.os.IInterface iin = obj.queryLocalInterface(DESCRIPTOR);
if (((iin!=null)&&(iin instanceof com.android.internal.telephony.getlocation))) {
return ((com.android.internal.telephony.getlocation)iin);
}
return new com.android.internal.telephony.getlocation.Stub.Proxy(obj);
}
@Override public android.os.IBinder asBinder()
{
return this;
}
@Override public boolean onTransact(int code, android.os.Parcel data, android.os.Parcel reply, int flags) throws android.os.RemoteException
{
switch (code)
{
case INTERFACE_TRANSACTION:
{
reply.writeString(DESCRIPTOR);
return true;
}
case TRANSACTION_registCallback:
{
data.enforceInterface(DESCRIPTOR);
com.android.internal.telephony.activitylocation _arg0;
_arg0 = com.android.internal.telephony.activitylocation.Stub.asInterface(data.readStrongBinder());
this.registCallback(_arg0);
reply.writeNoException();
return true;
}
}
return super.onTransact(code, data, reply, flags);
}
private static class Proxy implements com.android.internal.telephony.getlocation
{
private android.os.IBinder mRemote;
Proxy(android.os.IBinder remote)
{
mRemote = remote;
}
@Override public android.os.IBinder asBinder()
{
return mRemote;
}
public java.lang.String getInterfaceDescriptor()
{
return DESCRIPTOR;
}
@Override public void registCallback(com.android.internal.telephony.activitylocation activity) throws android.os.RemoteException
{
android.os.Parcel _data = android.os.Parcel.obtain();
android.os.Parcel _reply = android.os.Parcel.obtain();
try {
_data.writeInterfaceToken(DESCRIPTOR);
_data.writeStrongBinder((((activity!=null))?(activity.asBinder()):(null)));
mRemote.transact(Stub.TRANSACTION_registCallback, _data, _reply, 0);
_reply.readException();
}
finally {
_reply.recycle();
_data.recycle();
}
}
}
static final int TRANSACTION_registCallback = (android.os.IBinder.FIRST_CALL_TRANSACTION + 0);
}
public void registCallback(com.android.internal.telephony.activitylocation activity) throws android.os.RemoteException;
}
